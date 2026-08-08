import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/wallet_model.dart';
import '../../data/repositories/reward_repository_impl.dart';

// Events
abstract class RewardEvent {}
class GetWalletEvent extends RewardEvent {}
class ConvertPointsEvent extends RewardEvent {
  final int points;
  ConvertPointsEvent(this.points);
}

// States
enum RewardStatus { initial, loading, success, error, converting, conversionSuccess }
class RewardState {
  final RewardStatus status;
  final WalletModel? wallet;
  final String? errorMessage;
  final String? successMessage;

  RewardState({
    this.status = RewardStatus.initial,
    this.wallet,
    this.errorMessage,
    this.successMessage,
  });

  RewardState copyWith({
    RewardStatus? status,
    WalletModel? wallet,
    String? errorMessage,
    String? successMessage,
  }) {
    return RewardState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}

// Bloc
class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardRepository _rewardRepository;

  RewardBloc(this._rewardRepository) : super(RewardState()) {
    on<GetWalletEvent>((event, emit) async {
      emit(state.copyWith(status: RewardStatus.loading));
      try {
        final response = await _rewardRepository.getWallet();
        if (response.success && response.data != null) {
          emit(state.copyWith(status: RewardStatus.success, wallet: response.data));
        } else {
          emit(state.copyWith(status: RewardStatus.error, errorMessage: response.message));
        }
      } catch (e) {
        emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
      }
    });

    on<ConvertPointsEvent>((event, emit) async {
      emit(state.copyWith(status: RewardStatus.converting));
      try {
        final response = await _rewardRepository.convertPoints(event.points);
        if (response.success) {
          emit(state.copyWith(
            status: RewardStatus.conversionSuccess,
            successMessage: response.message,
          ));
          add(GetWalletEvent()); // Automatic refresh
        } else {
          emit(state.copyWith(status: RewardStatus.error, errorMessage: response.message));
        }
      } catch (e) {
        emit(state.copyWith(status: RewardStatus.error, errorMessage: e.toString()));
      }
    });
  }
}
