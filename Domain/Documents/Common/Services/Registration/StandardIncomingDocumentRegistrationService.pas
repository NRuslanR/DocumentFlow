unit StandardIncomingDocumentRegistrationService;

interface

uses

  StandardDocumentRegistrationService,
  IDocumentUnit,
  Document,
  DocumentNumerator,
  SysUtils,
  DocumentRegistrationService,
  DepartmentUnit,
  Classes;

type

  TStandardIncomingDocumentRegistrationService =
    class (TStandardDocumentRegistrationService)

      protected

        procedure RaiseExceptionIfDocumentIsNotIncoming(Document: TDocument);
        
        function GetDocumentNumber(Document: TDocument): String; override;
        function GetDocumentDate(Document: TDocument): TDateTime; override;
        
        procedure AssignNumber(
          Document: TDocument;
          AcceptingDepartment: TDepartment
        ); override;
        
        procedure AssignDate(Document: TDocument); override;

    end;

implementation

uses

  IncomingDocument;

{ TStandardIncomingDocumentRegistrationService }

procedure TStandardIncomingDocumentRegistrationService.AssignDate(
  Document: TDocument
);
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  with Document as TIncomingDocument do
    ReceiptDate := Now;

end;

procedure TStandardIncomingDocumentRegistrationService.AssignNumber(
  Document: TDocument;
  AcceptingDepartment: TDepartment
);
var IncomingDocument: TIncomingDocument;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  IncomingDocument := Document as TIncomingDocument;

  IncomingDocument.IncomingNumber :=
    GenerateNewDocumentNumber(Document, AcceptingDepartment);

end;

function TStandardIncomingDocumentRegistrationService.GetDocumentDate(
  Document: TDocument
): TDateTime;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  Result := (Document as TIncomingDocument).ReceiptDate;
  
end;

function TStandardIncomingDocumentRegistrationService.GetDocumentNumber(
  Document: TDocument
): String;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  Result := (Document as TIncomingDocument).IncomingNumber;

end;

procedure TStandardIncomingDocumentRegistrationService.
  RaiseExceptionIfDocumentIsNotIncoming(
    Document: TDocument
  );
begin

  if not (Document is TIncomingDocument) then
    raise TDocumentRegistrationServiceException.Create(
            'Обнаружена попытка ' +
            'регистрации НЕ входящего ' +
            'документа'
          );
  
end;

end.
