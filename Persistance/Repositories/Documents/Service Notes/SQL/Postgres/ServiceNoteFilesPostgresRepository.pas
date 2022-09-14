unit ServiceNoteFilesPostgresRepository;

interface

uses

  ServiceNote,
  AbstractDBRepository,
  DocumentFilesPostgresRepository,
  SysUtils,
  Classes;

type

  TServiceNoteFilesPostgresRepository =
    class (TDocumentFilesPostgresRepository)

      private

        procedure SetServiceNoteAsDocumentType;

      protected

        procedure Initialize; override;

    end;

implementation

{ TServiceNoteFilesPostgresRepository }


procedure TServiceNoteFilesPostgresRepository.Initialize;
begin

  inherited;

  SetServiceNoteAsDocumentType;
  
end;

procedure TServiceNoteFilesPostgresRepository.SetServiceNoteAsDocumentType;
begin

  ///DocumentType := TServiceNote;
  
end;

end.
