% function jmb_init()
% This function setup classpaths to files in jar subfolder
%
% Using ClassPathHacker to add the classpaths into STATIC path is necessary for callback functions 
% (eg. ListenerCallBack).  Alternatively, one can modify $MATLABROOT/toolbox/local/classpath.txt 
% to put these jars into static path.
% 
% For people using non-callback listeners (eg. Listener.m), standard javaaddpath() is sufficient

function jmb_init()
	clear java
	JARPATH=[pwd '/jars/'];
	USE_STATIC_PATH=1;
	jarfiles=dir([JARPATH '/*.jar']);
	javaaddpath('jars/edu.ucsd-0.0.0.jar');

	for j=jarfiles(:)'
		if USE_STATIC_PATH
			edu.ucsd.ClassPathHacker.addFile( [JARPATH '/' j.name]);
		else
			javaaddpath([JARPATH '/' j.name])
		end
	end
	javaaddpath(pwd)

%To check where a class is loaded from use:
%whereisjavaclassloadingfrom('edu.ucsd.SubscriberAdapter')
%cl=java.lang.ClassLoader.getSystemClassLoader();urls=cl.getURLs;urls(end)
