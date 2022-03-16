abstract class CheckinSubmissionStatus {
  const CheckinSubmissionStatus();
}

class InitialCheckinStatus extends CheckinSubmissionStatus {
  const InitialCheckinStatus();
}

class CheckinSubmitting extends CheckinSubmissionStatus {}

class CheckinSubmissionSuccess extends CheckinSubmissionStatus {}

class CheckinSubmissionFaied extends CheckinSubmissionStatus {
  final String exception;
  CheckinSubmissionFaied(this.exception);
}
