atsne_texture_cmd.exe mnist70000.bin MNIST_emb.bin 70000 784

mean square distance : 2.12476e+06
Computing gradient descent...
... done!
Data loading (sec):    0.057557
Similarities computation (sec): 21.2618
Gradient descent (sec): 10.5109
Data saving (sec):     0.0079231


atsne_texture_cmd --help

Usage: atsne_texture_cmd.exe [options] data output num_data_points num_dimensions
Command line version of the tSNE algorithm

Options:
  -?, -h, --help                         Displays this help.
  -v, --version                          Displays version information.
  -o, --verbose                          Verbose
  -i, --iterations <iterations>             Run the gradient for
                                      <iterations>.
  -d, --target_dimensions <target_dimensions>  Reduce the dimensionality to
                                      <target_dimensions>.
  -x, --exaggeration_iter <exaggeration_iter>  Remove the exaggeration factor
                                      after <exaggeration_iter>
                                      iterations.
  -p, --perplexity <perplexity>             Use perplexity value of
                                      <perplexity>.
  -t, --theta <theta>                     Use theta value of <theta> in
                                      the BH computation [0 <= t <= 1].
  -s, --similarities <similarities>          Save the similarity matrix P in
                                      <similarities>.
									  
Arguments:
  data                                 High dimensional data.
  output                                Output file.
  num_data_points                        Num of data-points.
  num_dimensions                         Num of dimensions.