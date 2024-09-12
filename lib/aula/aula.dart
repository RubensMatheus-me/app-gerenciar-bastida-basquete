main() {
  definirCor();
  print('abrir tela');
  print('carregar botões');
  print('carregar campos');
  print('carregar imagens');
}

buscarDados() async {
  await Future.delayed(const Duration(seconds: 3), () {
    print('carregar Dados');
  });
}

definirCor() {
  buscarDados().then(
    (e) => print('definir cor')
  );
}
