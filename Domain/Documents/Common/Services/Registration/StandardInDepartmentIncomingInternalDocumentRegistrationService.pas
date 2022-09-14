unit StandardInDepartmentIncomingInternalDocumentRegistrationService;

interface

uses

  StandardInDepartmentIncomingDocumentRegistrationService,
  Document,
  DepartmentUnit,
  DocumentRegistrationService,
  SysUtils,
  Classes;

type

  TStandardInDepartmentIncomingInternalDocumentRegistrationService =
    class (TStandardInDepartmentIncomingDocumentRegistrationService)

      protected

        function GenerateNewDocumentNumber(Document: TDocument): String; override;

    end;
  
implementation

uses

  IncomingDocument,
  InternalDocument;
  
{ TStandardInDepartmentIncomingInternalDocumentRegistrationService }

function TStandardInDepartmentIncomingInternalDocumentRegistrationService.
  GenerateNewDocumentNumber(Document: TDocument): String;
var IncomingDocument: TIncomingDocument;
begin

  if not (Document is TIncomingDocument)
  then begin

    raise TDocumentRegistrationServiceException.Create(
      'Обнаружена попытка регистрации ' +
      'НЕ входящего документа'
    );

  end;

  IncomingDocument := Document as TIncomingDocument;

  if not (IncomingDocument.OriginalDocument is TInternalDocument)
  then begin

    raise TDocumentRegistrationServiceException.Create(
      'Обнаружена попытка регистрации ' +
      'НЕ входящего внутреннего документа'
    );
  end;

  IncomingDocument.IncomingNumber := IncomingDocument.OriginalDocument.Number;
  
end;

end.
