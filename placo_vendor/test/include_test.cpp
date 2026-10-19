#include <cmath>
#include <iostream>

#include <placo/kinematics/kinematics_solver.h>
#include <placo/dynamics/dynamics_solver.h>
#include <placo/problem/problem.h>

int main()
{
  placo::problem::Problem problem;
  auto & x = problem.add_variable(1);
  problem.add_constraint(x.expr() == 1.0);
  problem.solve();

  if (x.value.size() != 1 || !std::isfinite(x.value[0]) ||
    std::abs(x.value[0] - 1.0) > 1e-8)
  {
    std::cerr << "PlaCo failed to solve x = 1\n";
    return 1;
  }

  std::cout << "PlaCo headers, exported target, and solver work\n";
  return 0;
}
