part of '../model/player_model.dart';

abstract class PlayerEvent {
  void solve(PlayerModel model);
}

class PlayingEvent implements PlayerEvent {
  @override
  void solve(PlayerModel model) {
    AudioPlayerService.instance.play();
  }
}

class PausingEvent implements PlayerEvent {
  @override
  void solve(PlayerModel model) {
    AudioPlayerService.instance.pause();
  }
}

class ShiftingStartEvent implements PlayerEvent{
  @override
  void solve(PlayerModel model) {
    // TODO: implement solve
  }
}

class ShiftingEndEvent implements PlayerEvent {
  @override
  void solve(PlayerModel model) {
    // TODO: implement handle
  }
}

abstract class SwitchEvent implements PlayerEvent {
  SwitchEvent();

  static Timer? _timer;

  bool _setTimer() {
    if (_timer != null) {
      return false;
    } else {
      _timer =
          new Timer(const Duration(milliseconds: 700), () => _timer = null);
      return true;
    }
  }
}

class ShiftSwitchEvent extends SwitchEvent {
  ShiftSwitchEvent(this.target);

  final int target;

  @override
  void solve(PlayerModel model) async {
    if (super._setTimer()) {
      await AudioPlayerService.instance.seek(Duration.zero);
      await AudioPlayerService.instance.skipToQueueItem(target);
    }
  }
}

class DrivenSwitchEvent extends SwitchEvent {
  DrivenSwitchEvent(this.previous);

  final bool previous;

  @override
  void solve(PlayerModel model) {
    if (super._setTimer()) {
      final service = AudioPlayerService.instance;
      if (previous) {
        service.skipToPrevious();
      } else {
        service.skipToNext();
      }
    }
  }
}
