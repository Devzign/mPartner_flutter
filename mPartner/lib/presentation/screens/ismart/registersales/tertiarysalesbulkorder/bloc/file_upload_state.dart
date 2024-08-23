part of 'file_upload_bloc.dart';


class FileUploadState extends Equatable {
  final bool? isUploadedSuccessfully;
  final RequestState fileUploadState;
  final String fileUploadMessage;

  const FileUploadState({
    this.isUploadedSuccessfully = false,
    this.fileUploadState = RequestState.loading,
    this.fileUploadMessage = '',
  });
  FileUploadState copyWith({
    bool? isUploadedSuccessfully,
    RequestState? fileUploadState,
    String? fileUploadMessage,
  }){
    return FileUploadState(
      isUploadedSuccessfully: isUploadedSuccessfully ?? this.isUploadedSuccessfully,
      fileUploadState: fileUploadState ?? this.fileUploadState,
      fileUploadMessage: fileUploadMessage ?? this.fileUploadMessage,
    );
  }
  @override
  List<Object?> get props => [
    isUploadedSuccessfully,
    fileUploadState,
    fileUploadMessage,
  ];
}

