import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  R get asRight => (this as Right).value as R;
  L get asLeft => (this as Left).value as L;
}