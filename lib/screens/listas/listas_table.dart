// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ulist/get_it.dart';
import 'package:ulist/models/lista_model/lista_model.dart';
import 'package:ulist/screens/listas/bloc/listas_bloc.dart';
import 'package:ulist/screens/listas/bloc/listas_event.dart';
import 'package:ulist/screens/listas/bloc/listas_state.dart';
import 'package:ulist/widgets/app_bar_custom/app_bar_custom.dart';
import 'package:ulist/widgets/lista_cadastro/lista_cadastro.dart';
import 'package:ulist/widgets/modal/modal.dart';
import 'package:ulist/widgets/modal_confirmacao/modal_confirmacao.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/search_bar_custom/search_bar_custom.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ListasTable extends StatefulWidget {
  const ListasTable({super.key});

  @override
  State<ListasTable> createState() => _ListasTableState();
}

class _ListasTableState extends State<ListasTable> {
  final ListasBloc listasBloc = getIt<ListasBloc>();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController search = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isSearching = ValueNotifier(false);

  String? currentPath;

  void searchList(String search) {
    listasBloc.add(SearchListasEvent(search: search));
  }

  Future<void> cadastroPopUp({required BuildContext context, ListaModel? initialValue}) {
    return Modal.right(
      context: context,
      width: 500,
      body: ListaCadastro(
        initialValue: initialValue,
        onComplete: (lista, completer, button) {
          if (initialValue == null) {
            listasBloc.add(
              CreateListasEvent(registro: lista, button: button, completer: completer),
            );
          } else {
            var registro = initialValue.copyWith(
              name: lista.name,
              description: lista.description,
              updatedAt: lista.updatedAt,
            );

            listasBloc.add(
              UpdateListasEvent(registro: registro, button: button, completer: completer),
            );
          }
        },
      ),
    );
  }

  Future<void> removePopUp({required BuildContext context, required ListaModel registro}) {
    return Modal.right(
      context: context,
      width: 500,
      body: ModalConfirmacao(
        title: 'Tem certeza que deseja remover a lista ${registro.name.toUpperCase()}',
        substitle: 'Junto com ela serão removidos todas as tarefas',
        onComplete: (value, completer, button) {
          if (value) {
            listasBloc.add(
              RemoveListasEvent(registro: registro, button: button, completer: completer),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: PaletteColors.background,
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 200.0,
                  toolbarHeight: 70,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Container(
                    color: PaletteColors.white,
                    child: LayoutBuilder(
                      builder: (ctx, contentConstraints) {
                        return FlexibleSpaceBar(
                          titlePadding: const EdgeInsetsDirectional.only(start: 0, bottom: 16),
                          title: IgnorePointer(
                            ignoring: _scrollController.position.pixels < 100,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut,
                              opacity: _scrollController.position.pixels > 100 ? 1 : 0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 56,
                                      height: 56,
                                      child: Icon(Icons.menu),
                                      // child: MenuButton(constraints: contentConstraints, scaffoldKey: _key),
                                    ),
                                    const Expanded(
                                      child: H1Small('Listas'),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      width: 50,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isSearching.value = true;
                                          });
                                          searchFocus.requestFocus();
                                        },
                                        icon: const Icon(
                                          Icons.search,
                                          color: PaletteColors.info,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          background: RefreshIndicator(
                            color: PaletteColors.primary,
                            backgroundColor: Colors.white,
                            onRefresh: () async => listasBloc.add(FetchListasEvent()),
                            child: CustomScrollView(
                              slivers: [
                                AppBarCustom(
                                  isSearching: isSearching,
                                  searchFunction: searchList,
                                  scaffoldKey: _key,
                                  search: search,
                                  searchFocus: searchFocus,
                                ),
                                SliverToBoxAdapter(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 24),
                                            child: const ListTile(
                                              title: H1Small('Listas'),
                                              subtitle: Paragraph('Mantenha suas tarefas organizadas com ajuda das listas'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ];
            },
            body: StreamBuilder<ListasState>(
              stream: listasBloc.stream,
              builder: (context, snapshot) {
                switch (listasBloc.state.runtimeType) {
                  case ListasInitialState:
                  case ListasLoadingState:
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          sliver: SliverStack(
                            children: [
                              const SliverPositioned.fill(
                                child: Card(),
                              ),
                              SliverToBoxAdapter(
                                child: ListTile(
                                  title: const TableHeader('Tarefas'),
                                  subtitle: const Paragraph('Lista de tarefas para a data selecionada'),
                                  trailing: IconButton(
                                    onPressed: () => listasBloc.add(FetchListasEvent()),
                                    icon: const Icon(
                                      Icons.sync,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
                                sliver: SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: ListTile(
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 1,
                                          color: PaletteColors.primary,
                                        ),
                                      ),
                                      title: const TableHeader('Buscando pelas listas'),
                                      subtitle: const Paragraph('Não deve levar muito tempo'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  default:
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          sliver: SliverStack(
                            children: [
                              const SliverPositioned.fill(
                                child: Card(),
                              ),
                              SliverToBoxAdapter(
                                child: ListTile(
                                  title: const TableHeader('Tarefas'),
                                  subtitle: const Paragraph('Lista de tarefas para a data selecionada'),
                                  trailing: IconButton(
                                    onPressed: () => listasBloc.add(FetchListasEvent()),
                                    icon: const Icon(
                                      Icons.sync,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
                                sliver: listasBloc.state.listas.isEmpty
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 24),
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.sentiment_very_dissatisfied,
                                              size: 18,
                                            ),
                                            title: search.text.isNotEmpty ? const TableHeader('Nenhuma lista encontrada') : const TableHeader('Nenhuma lista cadastrada'),
                                            subtitle: const Paragraph('Cadastre sua lista'),
                                          ),
                                        ),
                                      )
                                    : SliverList.separated(
                                        itemCount: listasBloc.state.listas.length,
                                        itemBuilder: (context, index) {
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: ListTile(
                                              onTap: () => context.go('/listas/${listasBloc.state.listas[index].id}'),
                                              leading: const Icon(
                                                Icons.fact_check,
                                                size: 18,
                                              ),
                                              title: TableHeader(listasBloc.state.listas[index].name),
                                              subtitle: Paragraph(listasBloc.state.listas[index].description),
                                              trailing: Wrap(
                                                spacing: 4,
                                                runSpacing: 4,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 18,
                                                      color: PaletteColors.info,
                                                    ),
                                                    onPressed: () => cadastroPopUp(
                                                      context: context,
                                                      initialValue: listasBloc.state.listas[index],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.clear,
                                                      size: 18,
                                                      color: PaletteColors.info,
                                                    ),
                                                    onPressed: () => removePopUp(context: context, registro: listasBloc.state.listas[index]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, index) => Divider(
                                          height: 0,
                                          color: PaletteColors.info.withOpacity(0.1),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ),
          SearchBarCustom(
            isSearching: isSearching,
            searchFunction: searchList,
            search: search,
            searchFocus: searchFocus,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PaletteColors.primary,
        onPressed: () => cadastroPopUp(context: context),
        tooltip: 'Cadastrar tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }
}
