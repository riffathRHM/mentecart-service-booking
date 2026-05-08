import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/domain/usecases/service/get_service_detail_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/service/get_services_usecase.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final GetServicesUsecase getServicesUsecase;
  final GetServiceDetailUsecase getServiceDetailUsecase;

  ServiceBloc({
    required this.getServicesUsecase,
    required this.getServiceDetailUsecase,
  }) : super(const ServiceInitial()) {
    on<GetServicesEvent>(_onGetServices);
    on<GetServiceDetailEvent>(_onGetServiceDetail);
  }

  Future<void> _onGetServices(
    GetServicesEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    try {
      final result = await getServicesUsecase(
        GetServicesParams(
          page: event.page,
          limit: event.limit,
          category: event.category,
          search: event.search,
        ),
      );

      result.fold(
        (failure) => emit(ServiceError(failure.message)),
        (services) {
          AppLogger.info('Loaded ${services.length} services');
          emit(
            ServicesLoaded(
              services: services,
              total: services.length,
              hasMore: services.length >= event.limit,
            ),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Get services error: $e');
      emit(ServiceError('Failed to load services'));
    }
  }

  Future<void> _onGetServiceDetail(
    GetServiceDetailEvent event,
    Emitter<ServiceState> emit,
  ) async {
    emit(const ServiceLoading());

    try {
      final result = await getServiceDetailUsecase(
        GetServiceDetailParams(serviceId: event.serviceId),
      );

      result.fold(
        (failure) => emit(ServiceError(failure.message)),
        (service) {
          AppLogger.info('Loaded service: ${service.title}');
          emit(ServiceDetailLoaded(service: service));
        },
      );
    } catch (e) {
      AppLogger.error('Get service detail error: $e');
      emit(ServiceError('Failed to load service details'));
    }
  }
}