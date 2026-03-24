/// Base use case interface for all use cases
///
/// Use cases encapsulate business logic and orchestrate data flow
/// between the presentation and data layers.
library;

import 'package:dartz/dartz.dart';
import 'package:crack_the_code/core/errors/failures.dart';

/// Base use case interface with parameters
///
/// [Type] is the return type
/// [Params] is the parameters type
abstract class BaseUseCase<Type, Params> {
  /// Execute the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// Base use case interface for use cases that don't require parameters
abstract class NoParamsUseCase<Type> {
  /// Execute the use case
  Future<Either<Failure, Type>> call();
}

/// Base use case interface for Stream-based use cases
abstract class StreamUseCase<Type, Params> {
  /// Execute the use case and return a stream
  Stream<Either<Failure, Type>> call(Params params);
}

/// Base use case interface for Stream-based use cases without parameters
abstract class NoParamsStreamUseCase<Type> {
  /// Execute the use case and return a stream
  Stream<Either<Failure, Type>> call();
}

/// Marker class for use cases that don't require parameters
class NoParams {
  const NoParams();
}
