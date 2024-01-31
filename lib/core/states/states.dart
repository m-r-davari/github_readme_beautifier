abstract class UIState {

}


class InitialState extends UIState {

}

class LoadingState extends UIState {

}


class SuccessState<T> extends UIState{
  T data;
  SuccessState(this.data);
}


class FailureState extends UIState{
  String error;
  FailureState({this.error = 'Something went wrong'});
}