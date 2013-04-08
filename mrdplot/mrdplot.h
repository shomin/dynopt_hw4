/*************************************************************************/

typedef struct mrdplot_data
{
  const char *filename;
  int total_n_numbers;
  int n_points;
  int n_channels;
  float frequency;
  float *data;
  const char **names;
  const char **units;
} MRDPLOT_DATA;

/*************************************************************************/
