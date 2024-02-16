class Result<T, E> {
  T? value;
  E? error;

  Result.Ok(T value) {
    this.value = value;
  }

  Result.Err(E error) {
    this.error = error;
  }
}
