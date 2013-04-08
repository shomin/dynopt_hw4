mrdplot is data plotting software that runs in Matlab.
Put the .m files in a directory in your Matlab path (see set path
command).

mrdplot.c and mrdplot.h are routines to make it easier to read
and write mrdplot format data files.

data is stored grouped by time:
at time = 0: c0 c1 c2 ....
at time = 1: c0 c1 c2 ....
...

To access sequentially:
for ( i = 0; i < d->n_points; i++ )
  for ( j = 0; j < d->n_channels; j++ )
    {
      d->data[i*d->n_channels + j];
    }
