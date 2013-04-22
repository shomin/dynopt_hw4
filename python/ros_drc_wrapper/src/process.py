#!/usr/bin/python

import os
import signal
from subprocess import Popen, PIPE
import time
import threading
import Queue

class Process(object):
    def __init__(self, cmd, stdin=False, stdout=False, stderr=False):
        self._stdin = self._stderr = self._stdout = None
        if stdin:
            stdin=PIPE
            self._stdin = Queue.Queue(0)  
        if stdout:
            stdout=PIPE
            self._stdout = Queue.Queue(0)
        if stderr:
            stderr=PIPE
            self._stderr = Queue.Queue(0)
        self._proc = Popen(cmd, shell=False, stdin=stdin, stdout=stdout, stderr=stderr)  
        self.threading = True
        threading.Thread(target=self._inThread).start()
        threading.Thread(target=self._outThread).start()
        threading.Thread(target=self._errThread).start()
        self.pid = self._proc.pid
    
    def kill(self):
        os.kill(self.pid, signal.SIGTERM)
        self.wait()
    
    def wait(self):
        self._proc.wait()
        self.threading = False
    
    def write(self, msg):
        if self._stdin:
            self._stdin.put(msg)
    
    def empty(self, device):
        if device == 'stdout' and self._stdout:
            return self._stdout.empty()
        elif device == 'stderr' and self._stderr:
            return self._stderr.empty()
    
    def readline(self, device, block=True, timeout=None):
        if device == 'stdout' and self._stdout:
            try:
                return self._stdout.get(block=block, timeout=timeout)
            except Queue.Empty:
                return None
        elif device == 'stderr' and self._stderr:
            try:
                return self._stderr.get(block=block, timeout=timeout)
            except Queue.Empty:
                return None
    
    def _inThread(self):
        while self.threading and self._stdin != None:
            if not self._stdin.empty():
                self._proc.stdin.write(self._stdin.get()+'\n')
    
    def _outThread(self):
        while self.threading and self._stdout != None:
            data = self._proc.stdout.readline()#.strip()
            if data != '':
                self._stdout.put(data)
        
    def _errThread(self):
        while self.threading and self._stderr != None:
            data = self._proc.stderr.readline()#.strip()
            if data != '':
                self._stderr.put(data)

if __name__=='__main__':
    proc = Process('python stressTest2.py', stdout=True)
    proc.wait()
    
    while not proc.empty('stdout'):
        print proc.readline('stdout', block=True)

