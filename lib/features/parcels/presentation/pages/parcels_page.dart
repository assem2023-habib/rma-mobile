import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import '../widgets/parcel_card.dart';

class ParcelsPage extends StatefulWidget {
  const ParcelsPage({super.key});

  @override
  State<ParcelsPage> createState() => _ParcelsPageState();
}

class _ParcelsPageState extends State<ParcelsPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<ParcelsBloc>().add(GetParcelsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<ParcelsBloc>().state;
      if (state is ReturnedParcelsLoaded) {
        if (state.parcelsPagination.currentPage <
            state.parcelsPagination.lastPage) {
          _currentPage = state.parcelsPagination.currentPage + 1;
          context
              .read<ParcelsBloc>()
              .add(GetReturnedParcelsEvent(page: _currentPage));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('طرودي', style: AppTypography.heading2),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'المرتجعة'),
            ],
            labelStyle: AppTypography.bodyMedium,
            indicatorColor: AppColors.primary,
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
          ],
        ),
        body: TabBarView(
          children: [
            _buildAllParcelsTab(),
            _buildReturnedParcelsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllParcelsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: TextField(
            onChanged: (value) {
              context.read<ParcelsBloc>().add(SearchParcelsEvent(value));
            },
            decoration: const InputDecoration(
              hintText: 'البحث عن طرد برقم التتبع أو الاسم...',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
                vertical: AppDimensions.spacing3,
              ),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<ParcelsBloc, ParcelsState>(
            builder: (context, state) {
              if (state is ParcelsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ParcelsError) {
                return Center(child: Text(state.message));
              } else if (state is ParcelsLoaded) {
                if (state.parcels.isEmpty) {
                  return _buildEmptyState();
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing4,
                  ),
                  itemCount: state.parcels.length,
                  itemBuilder: (context, index) {
                    final parcel = state.parcels[index];
                    return ParcelCard(
                      parcel: parcel,
                      onTap: () {
                        context.push('/parcels/${parcel.id}', extra: parcel);
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReturnedParcelsTab() {
    return BlocBuilder<ParcelsBloc, ParcelsState>(
      builder: (context, state) {
        if (state is ParcelsInitial || (state is ParcelsLoading && _currentPage == 1)) {
          // Trigger fetch if initial
          context.read<ParcelsBloc>().add(const GetReturnedParcelsEvent(page: 1));
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ParcelsLoading && _currentPage == 1) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ParcelsError) {
          return Center(child: Text(state.message));
        } else if (state is ReturnedParcelsLoaded) {
          final parcels = state.parcelsPagination.data;
          if (parcels.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing4,
              vertical: AppDimensions.spacing4,
            ),
            itemCount: parcels.length + (state.parcelsPagination.currentPage < state.parcelsPagination.lastPage ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < parcels.length) {
                final parcel = parcels[index];
                return ParcelCard(
                  parcel: parcel,
                  onTap: () {
                    context.push('/parcels/${parcel.id}', extra: parcel);
                  },
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.spacing4),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        }
        
        // If we are in another state (like ParcelsLoaded), we should still show the fetch trigger or handle it
        return Center(
          child: ElevatedButton(
            onPressed: () {
              _currentPage = 1;
              context.read<ParcelsBloc>().add(const GetReturnedParcelsEvent(page: 1));
            },
            child: const Text('تحميل الطرود المرتجعة'),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: AppColors.slate300,
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            'لا توجد طرود حالياً',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }
}
