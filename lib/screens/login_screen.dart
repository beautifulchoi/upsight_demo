import 'package:flutter/material.dart';
import 'package:board_project/screens/login_secure.dart';
import 'package:provider/provider.dart';
import 'package:board_project/screens/model_login.dart';
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginFieldModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("로그인 화면"),
        ),
        body: Column(
          children: [
            EmailInput(),
            PasswordInput(),
            LoginButton(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 1),
            ),
            RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginField = Provider.of<LoginFieldModel>(context);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TextField(
        onChanged: (email) {
          loginField.setEmail(email);
        },
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: '이메일',
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final loginField = Provider.of<LoginFieldModel>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TextField(
        onChanged: (password) {
          loginField.setPassword(password);
        },
        obscureText: true,
        decoration: const InputDecoration(
          labelText: '비밀번호',
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authClient =
    Provider.of<FirebaseAuthProvider>(context, listen: false);
    final loginField = Provider.of<LoginFieldModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          await authClient
              .signIn(loginField.email, loginField.password)
              .then((loginStatus) {
            if (loginStatus == AuthStatus.loginSuccess) {
              logger.d("로그인 성공");
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(authClient.authClient.currentUser!.email! + '님 환영합니다!')), // 닉네임 가져온느거로 수정해야함
                );
              Navigator.pushReplacementNamed(context, '/tab');
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')),
                );
            }
          });
        },
        child: Text('로그인'),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/register');
      },
      child: Text(
        '이메일로 간단하게 회원가입 하기',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}