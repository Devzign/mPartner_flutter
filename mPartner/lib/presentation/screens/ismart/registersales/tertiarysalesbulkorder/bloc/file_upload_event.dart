part of 'file_upload_bloc.dart';

@immutable
abstract class FileUploadEvent extends Equatable{
  const FileUploadEvent();

  @override
  List<Object> get props => [];
}

class SelectFileEvent extends FileUploadEvent {}

class PostFileEvent extends FileUploadEvent{
  final String fileName;
  final String filePath;

  PostFileEvent({
    required this.fileName,
    required this.filePath});

  @override
  List<Object> get props => [fileName,filePath];
}
