abstract class PermissionSubmissionStatus {
  const PermissionSubmissionStatus();
}

class InitialFormStatus extends PermissionSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends PermissionSubmissionStatus {

}


class SubmissionSuccess extends PermissionSubmissionStatus {

}


class SubmissionFaied extends PermissionSubmissionStatus {
  final String exception;
  SubmissionFaied(this.exception);

}
