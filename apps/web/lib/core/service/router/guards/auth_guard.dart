import 'package:auto_route/auto_route.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lvm_telephony_web/core/service/router/router.dart';

class AuthGuard extends AutoRouteGuard {
  const AuthGuard();
  
  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final user = GetIt.I<UserStorage>().user;
    if (user != null) return resolver.next();
    router.push(const SignInRoute());
  }
}