import 'dart:math';

double sigmoid(double x, [ double power = -1 ]) => 1 / (1 + pow(e, power * x));

// double polyfit(List<double> x, List<double> y, List<double> weights, [int degree = 2]) {
//   if(x.length == 0) return null;
//
//   List<double> s = weights.map((e) => sqrt(e));
//
//   X = x[
//   :, None]**np.arange(degree + 1)
//   X0 = x0[:, None]**np.arange(degree + 1)
//
//   lhs = X*s[:, None]
//   rhs = y*s
//
//   # This is what NumPy uses for default from version 1.15 onwards,
//   # and what 1.14 uses when rcond=None. Computing it here ensures
//   # support for older versions of NumPy.
//   rcond = np.finfo(lhs.dtype).eps * max(*lhs.shape)
//
//   beta = np.linalg.lstsq(lhs, rhs, rcond=rcond)[0]
//
//   return
//   X0
//   .
//   dot
//   (
//   beta
//   )
// }

List<double> localreg(List<double> x, [ int width = 1 ]) {
  //rbf.epanechnikov
  List<double> r = List.filled(x.length, 0);


  for(int i = 0; i < x.length; i++) {
    List<double> weights = x.map((e) => sigmoid((x.indexOf(e) - i).abs() / width, 0.6) * 2).toList();

    // print(weights);

    double counter = 0;
    double sum = 0;
    for(int j = 0; j < weights.length; j++) {
      if(weights[j] <= 0.1) continue;

      sum += weights[j] * x[j];
      counter += weights[j];
    }

    sum /= counter;
    r[i] = sum;
    // Filter out the datapoints with zero weights.
    // Speeds up regressions with kernels of local support.
    // inds = np.where(np.abs(weights)>1e-10)[0]

    // r[i] = polyfit(x, y, weights, degree);

  }

  return r.toList();
}