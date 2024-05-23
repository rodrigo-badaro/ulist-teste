// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ulist/models/item_model/item_model.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/lista_detalhes_event.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/lista_detalhes_state.dart';
import 'package:ulist/screens/listas/lista_detalhes_bloc/listas_datalhes_bloc.dart';
import 'package:ulist/widgets/app_bar_custom/app_bar_custom.dart';
import 'package:ulist/widgets/item_cadastro/item_cadastro.dart';
import 'package:ulist/widgets/item_detalhes/item_detalhes.dart';
import 'package:ulist/widgets/modal/modal.dart';
import 'package:ulist/widgets/modal_confirmacao/modal_confirmacao.dart';
import 'package:ulist/widgets/palette_colors/palette_colors.dart';
import 'package:ulist/widgets/search_bar_custom/search_bar_custom.dart';
import 'package:ulist/widgets/typography/typography.dart';

class ListaDetalhes extends StatefulWidget {
  const ListaDetalhes({super.key, required this.ref});
  final dynamic ref;

  @override
  State<ListaDetalhes> createState() => _ListaDetalhesState();
}

class _ListaDetalhesState extends State<ListaDetalhes> {
  final ListaDetalhesBloc bloc = ListaDetalhesBloc();

  final ScrollController _scrollController = ScrollController();
  final TextEditingController search = TextEditingController();
  final FocusNode searchFocus = FocusNode();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> isSearching = ValueNotifier(false);

  String? currentPath;

  @override
  void initState() {
    super.initState();
    bloc.add(FetchListaDetalhesEvent(ref: widget.ref));
  }

  void searchList(String search) {
    bloc.add(SearchListaDetalhesEvent(search: search));
  }

  Future<void> cadastroPopUp({required BuildContext context, ItemModel? initialValue}) {
    return Modal.right(
      context: context,
      width: 500,
      body: ItemCadastro(
        initialValue: initialValue,
        onComplete: (item, completer, button) {
          if (initialValue == null) {
            bloc.add(
              CreateTarefaDetalhesEvent(registro: item, button: button, completer: completer),
            );
          } else {
            var registro = initialValue.copyWith(
              name: item.name,
              description: item.description,
              updatedAt: item.updatedAt,
              data: item.data,
              horario: item.horario,
            );

            bloc.add(
              UpdateTarefaDetalhesEvent(registro: registro, button: button, completer: completer),
            );
          }
        },
      ),
    );
  }

  Future<void> detalhesPopUp({required BuildContext context, required ItemModel initialValue}) {
    return Modal.right(
      context: context,
      width: 500,
      body: ItemDetalhes(
        initialValue: initialValue,
      ),
    );
  }

  Future<void> removePopUp({required BuildContext context, required ItemModel? registro}) {
    return Modal.right(
      context: context,
      width: 500,
      body: ModalConfirmacao(
        title: 'Tem certeza que deseja remover a tarefa ${registro?.name.toUpperCase()}',
        substitle: 'Você não poderá acessar novamente esta tarefa',
        onComplete: (value, completer, button) {
          if (value) {
            bloc.add(
              RemoveTarefaDetalhesEvent(registro: registro, button: button, completer: completer),
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
                            onRefresh: () async => bloc.add(FetchListaDetalhesEvent(ref: widget.ref)),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12, top: 12),
                                    child: StreamBuilder<ListaDetalhesState>(
                                        stream: bloc.stream,
                                        builder: (context, snapshot) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SelectionContainer.disabled(
                                                    child: InkWell(
                                                      onTap: () => context.go('/listas'),
                                                      child: const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12),
                                                        child: SmallText(
                                                          'LISTAS',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(right: 12),
                                                    child: Icon(
                                                      Icons.chevron_right,
                                                      size: 16,
                                                      color: PaletteColors.info,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: SmallText(
                                                      bloc.state.lista?.name.toUpperCase() ?? '',
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ListTile(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                                title: H1Small(bloc.state.runtimeType == ListaDetalhesSuccessState ? bloc.state.lista?.name ?? '' : 'Carregando dados'),
                                                subtitle: Paragraph(bloc.state.lista?.description ?? ''),
                                              ),
                                            ],
                                          );
                                        }),
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
            body: StreamBuilder<ListaDetalhesState>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                switch (bloc.state.runtimeType) {
                  case ListaDetalhesInitialState:
                  case ListaDetalhesLoadingState:
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
                                    onPressed: () {},
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
                                    onPressed: () => bloc.add(FetchListaDetalhesEvent(ref: widget.ref)),
                                    icon: const Icon(
                                      Icons.sync,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
                                sliver: bloc.state.lista?.items.isEmpty ?? false
                                    ? SliverToBoxAdapter(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 24),
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.sentiment_very_dissatisfied,
                                              size: 18,
                                            ),
                                            title: search.text.isNotEmpty ? const TableHeader('Nenhuma tarefa encontrada') : const TableHeader('Nenhuma tarefa cadastrada'),
                                            subtitle: const Paragraph('Cadastre sua lista'),
                                          ),
                                        ),
                                      )
                                    : SliverList.separated(
                                        itemCount: bloc.state.lista?.items.length,
                                        itemBuilder: (context, index) {
                                          return Material(
                                            type: MaterialType.transparency,
                                            child: Opacity(
                                              opacity: bloc.state.lista!.items[index].loading ? 0.5 : 1,
                                              child: ListTile(
                                                onTap: () => detalhesPopUp(context: context, initialValue: bloc.state.lista!.items[index]),
                                                leading: bloc.state.lista?.items[index].completed ?? false
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        size: 18,
                                                        color: Colors.green,
                                                      )
                                                    : const Icon(
                                                        Icons.pending,
                                                        size: 18,
                                                        color: PaletteColors.info,
                                                      ),
                                                title: TableHeader(bloc.state.lista?.items[index].name ?? ''),
                                                subtitle: Paragraph(bloc.state.lista?.items[index].description ?? ''),
                                                trailing: Wrap(
                                                  spacing: 4,
                                                  runSpacing: 4,
                                                  children: [
                                                    bloc.state.lista!.items[index].loading
                                                        ? IconButton(
                                                            onPressed: () {},
                                                            icon: const SizedBox(
                                                              height: 18,
                                                              width: 18,
                                                              child: CircularProgressIndicator(
                                                                color: PaletteColors.primary,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          )
                                                        : IconButton(
                                                            onPressed: () {
                                                              var registro = bloc.state.lista!.items[index].copyWith(
                                                                completed: !bloc.state.lista!.items[index].completed,
                                                              );

                                                              bloc.add(
                                                                FinishTarefaDetalhesEvent(
                                                                  registro: registro,
                                                                ),
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.check_circle_outline,
                                                              size: 18,
                                                              color: PaletteColors.info,
                                                            ),
                                                          ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                        color: PaletteColors.info,
                                                      ),
                                                      onPressed: () => cadastroPopUp(
                                                        context: context,
                                                        initialValue: bloc.state.lista?.items[index],
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.clear,
                                                        size: 18,
                                                        color: PaletteColors.info,
                                                      ),
                                                      onPressed: () => removePopUp(context: context, registro: bloc.state.lista?.items[index]),
                                                    )
                                                  ],
                                                ),
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
