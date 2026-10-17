import '../errors/failures.dart';

class Result<T> {
  final T? _data;
  final Failure? _failure;

  const Result._(this._data, this._failure);

  factory Result.success(T data) => Result._(data, null);
  factory Result.failure(Failure failure) => Result._(null, failure);

  bool get isSuccess => _failure == null;
  bool get isFailure => _failure != null;

  T get data {
    if (isFailure) {
      throw StateError('Cannot retrieve data from a failed Result: $_failure');
    }
    return _data as T;
  }

  Failure get failure {
    if (isSuccess) {
      throw StateError('Cannot retrieve failure from a successful Result');
    }
    return _failure!;
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (isSuccess) {
      return success(_data as T);
    } else {
      return failure(_failure!);
    }
  }

  R fold<R>(R Function(Failure failure) onFailure, R Function(T data) onSuccess) {
    if (isSuccess) {
      return onSuccess(_data as T);
    } else {
      return onFailure(_failure!);
    }
  }
}
