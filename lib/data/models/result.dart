class Result<T, E> {
  T? value;
  E? error;

  Result.Ok(T this.value);

  Result.Err(E this.error);
}
