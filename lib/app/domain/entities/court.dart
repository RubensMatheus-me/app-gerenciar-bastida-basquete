import 'package:flutter/material.dart';

class Court extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var configuracao1 = Configuracao(context: context, color: Colors.red, width: 700, height: 700, mensagem: 'vermelho');
    var configuracao2 = Configuracao(context: context, color: Colors.blue, width: 550, height: 550, mensagem: 'azul');
    var configuracao3 = Configuracao(context: context, color: Colors.black, width: 300, height: 300, mensagem: 'preto');
    var configuracao4 = Configuracao(context: context, color: Colors.green, width: 100, height: 100, mensagem: 'verde');
    return Container(
        child: figura(
          configuracao: configuracao1,
          widget: figura(
            configuracao: configuracao2, 
            widget: figura(
              configuracao: configuracao3, 
              widget: figura(
                configuracao: configuracao4, 
              )
            )
          )
        ),                   
    );
  }


  Widget figura({required Configuracao configuracao,Widget? widget}){
    return Center ( 
      child: GestureDetector(
        child: Container(
          color: configuracao.color,
          width: configuracao.width,
          height: configuracao.height,
          child: widget,
        ),
        onTap: () {                          
        _showDialog(configuracao.context,configuracao.mensagem);
        }, 
      ),                 
    );
  }

  

  void _showDialog(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text(mensagem),
        );
      },
    );
  }
}

  class Configuracao{
    BuildContext context; 
    Color color; 
    double width;
    double height;
    String mensagem; 
    Configuracao({required this.context,required this.color,required this.width,required this.height,required this.mensagem});
  }

