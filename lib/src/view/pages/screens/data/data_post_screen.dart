import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:patinha_perdida_app/src/config/cutom_color_config.dart';
import 'package:patinha_perdida_app/src/dao/post_dao.dart';

class DataPostScreen extends StatefulWidget {
  const DataPostScreen({super.key});

  @override
  State<DataPostScreen> createState() => _DataPostScreenState();
}

class _DataPostScreenState extends State<DataPostScreen> {
  PostDAO postDao = PostDAO();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Obtera a quantidade total de registros
              FutureBuilder<int>(
                future: postDao.obterTotalRegistros(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se a operação estiver em andamento, exiba um indicador de carregamento
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se a operação for concluída com sucesso, exiba o total de registros
                    int totalRegistros = snapshot.data ?? 0;
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Total de relatos: ${totalRegistros.toInt()}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              Divider(color: Colors.grey[300]),

              //Porcentagem de animais machucados
              FutureBuilder<double>(
                future: postDao.obterPorcentagemRegistrosMachucado(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se a operação estiver em andamento, exiba um indicador de carregamento
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se a operação for concluída com sucesso, exiba o total de registros
                    double porcentagem = snapshot.data ?? 0;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Porcentagem de animais machucados",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: porcentagem,
                                    color: CustomColors.customContrastColor,
                                    title: '${porcentagem.toStringAsFixed(2)}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 100 - porcentagem,
                                    color: Colors.grey.withOpacity(0.2),
                                    title: '',
                                    radius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              //Porcentagem de animais desnutridos
              FutureBuilder<double>(
                future: postDao.obterPorcentagemRegistrosDesnutrido(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se a operação estiver em andamento, exiba um indicador de carregamento
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se a operação for concluída com sucesso, exiba o total de registros
                    double porcentagem = snapshot.data ?? 0;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Porcentagem de animais desnutridos",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: porcentagem,
                                    color: CustomColors.customContrastColor,
                                    title: '${porcentagem.toStringAsFixed(2)}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 100 - porcentagem,
                                    color: Colors.grey.withOpacity(0.2),
                                    title: '',
                                    radius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              //Porcentagem de animais que não possuem coleira
              FutureBuilder<double>(
                future: postDao.obterPorcentagemRegistrosColeira(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se a operação estiver em andamento, exiba um indicador de carregamento
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se a operação for concluída com sucesso, exiba o total de registros
                    double porcentagem = snapshot.data ?? 0;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Porcentagem de animais sem coleira",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: porcentagem,
                                    color: Colors.orange[800],
                                    title: '${porcentagem.toStringAsFixed(2)}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 100 - porcentagem,
                                    color: Colors.grey.withOpacity(0.2),
                                    title: '',
                                    radius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

              //Porcentagem de animais que não são dóceis
              FutureBuilder<double>(
                future: postDao.obterPorcentagemRegistrosDocil(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Se a operação estiver em andamento, exiba um indicador de carregamento
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Se ocorrer um erro, exiba uma mensagem de erro
                    return Text('Erro: ${snapshot.error}');
                  } else {
                    // Se a operação for concluída com sucesso, exiba o total de registros
                    double porcentagem = snapshot.data ?? 0;
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.all(8.0),
                      shadowColor: Colors.grey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Porcentagem de animais aparentemente não dóceis",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 1,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 5,
                                centerSpaceRadius: 70,
                                sections: [
                                  PieChartSectionData(
                                    value: porcentagem,
                                    color: Colors.orange[800],
                                    title: '${porcentagem.toStringAsFixed(2)}%',
                                    radius: 50,
                                    titleStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    value: 100 - porcentagem,
                                    color: Colors.grey.withOpacity(0.2),
                                    title: '',
                                    radius: 50,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
