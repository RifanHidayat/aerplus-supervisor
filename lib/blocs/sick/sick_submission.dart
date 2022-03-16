abstract class SickSubmissionStatus {
  const SickSubmissionStatus();
}

class InitialFormStatus extends SickSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends SickSubmissionStatus {

}


class SubmissionSuccess extends SickSubmissionStatus {

}


class SubmissionFaied extends SickSubmissionStatus {
  final String exception;
  SubmissionFaied(this.exception);

}
