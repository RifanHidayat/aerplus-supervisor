
class AttendanceState {

  bool? isLoading;
  bool? isLoaded;
  bool? isDeleting;
  bool? isDeleted;
  bool? isSaved;
  bool? hasFailure;
  bool? isSaving;

  AttendanceState({
    this.isLoading = false,
    this.isSaved = false,
    this.isDeleting = false,
    this.isDeleted = false,
    this.isSaving = false,
    this.hasFailure = false,
    this.isLoaded = false,
  });
}
