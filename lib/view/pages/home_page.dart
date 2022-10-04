import 'package:flutter/material.dart';

import '../../data/models/article.dart';
import '../../data/repositories/news/news.dart';
import '../widgets/home_page/news_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article>? articles;
  late TextEditingController controller;
  String? error;
  late FocusNode focusNode;
  DateTime from = DateTime.now().subtract(const Duration(days: 29));
  DateTime to = DateTime.now();
  bool loading = false;

  @override
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
  }

  void _setFromDate() async {
    final newFrom = await showDatePicker(
      context: context,
      initialDate: from,
      firstDate: DateTime.now().subtract(const Duration(days: 29)),
      lastDate: DateTime.now(),
    );
    if (newFrom != null) {
      setState(() {
        from = newFrom;
      });
      if (!focusNode.hasFocus) _getNews();
    }
  }

  void _setToDate() async {
    final newto = await showDatePicker(
      context: context,
      initialDate: from,
      firstDate: from,
      lastDate: DateTime.now(),
    );
    if (newto != null) {
      setState(() {
        to = newto;
      });
      if (!focusNode.hasFocus) _getNews();
    }
  }

  void _getNews() async {
    if (controller.value.text.isNotEmpty) {
      if (focusNode.hasFocus) FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        loading = true;
        error = null;
      });
      await NewsRepository.getEverything(
        'NO_TOKEN',
        q: controller.value.text.trim(),
        from: from,
        to: to,
        sortBy: 'publishedAt',
        onError: (errorMessage) => setState(() {
          error = errorMessage;
        }),
      ).then(
        (value) => setState(() {
          articles = value;
        }),
      );
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        error = 'Search cannot be empty';
      });
    }
  }

  Expanded _buildContent() {
    return Expanded(
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '⚠️\n${error!}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : articles?.isEmpty ?? true
                  ? const Center(
                      child: Text(
                        'No recent news!\nTry selecting an earlier date.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      itemCount: articles?.length ?? 0,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, i) => NewsTile(
                        article: articles![i],
                      ),
                    ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text('From:'),
                GestureDetector(
                  onTap: _setFromDate,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${from.day}/${from.month}/${from.year}'),
                  ),
                ),
                const Text('To:'),
                GestureDetector(
                  onTap: _setToDate,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('${to.day}/${to.month}/${to.year}'),
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  Padding _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search recent news',
          labelText: 'Search',
        ),
        onFieldSubmitted: (value) => _getNews(),
        validator: (String? value) {
          return (value == null || value.isEmpty)
              ? 'Search cannot be empty'
              : null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchField(),
          _buildContent(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNews,
        tooltip: 'Get news',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }
}
