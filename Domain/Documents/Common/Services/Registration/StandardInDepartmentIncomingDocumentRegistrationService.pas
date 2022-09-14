unit StandardInDepartmentIncomingDocumentRegistrationService;

interface

uses

  StandardInDepartmentDocumentRegistrationService,
  IDocumentUnit,
  Document,
  DocumentNumerator,
  SysUtils,
  DepartmentUnit,
  IDomainObjectUnit,
  DocumentRegistrationService,
  DocumentNumeratorRegistry,
  EmployeeFinder,
  IncomingDocument,
  DepartmentFinder,
  Employee,
  Classes;

type

  TStandardInDepartmentIncomingDocumentRegistrationService =
    class (TStandardInDepartmentDocumentRegistrationService)

      protected

        FEmployeeFinder: IEmployeeFinder;

      protected
        
        procedure RaiseExceptionIfDocumentIsNotIncoming(Document: TDocument);
        
        function GetDocumentNumber(Document: TDocument): String; override;
        function GetDocumentDate(Document: TDocument): Variant; override;
        
        procedure AssignNumber(
          Document: TDocument
        ); override;
        
        procedure AssignDate(Document: TDocument); override;

      protected

        procedure RaiseExceptionIfIncomingDocumentReceiverIsNotSpecified(
          IncomingDocument: TIncomingDocument
        );

        procedure RaiseExceptionIfDocumentIsSelfRegistered(
          Document: TDocument
        ); override;

      protected

        function GetRegistrationDepartmentIdForDocument(Document: TDocument): Variant; override;

      protected

        function IsDocumentSelfRegistered(Document: TDocument): Boolean; override;
        
      public

        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          DocumentNumeratorRegistry: IDocumentNumeratorRegistry
        );

    end;

implementation

uses

  Variants;
  
{ TStandardInDepartmentIncomingDocumentRegistrationService }

procedure TStandardInDepartmentIncomingDocumentRegistrationService.AssignDate(
  Document: TDocument
);
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  with TIncomingDocument(Document) do ReceiptDate := Now;

end;

procedure TStandardInDepartmentIncomingDocumentRegistrationService.AssignNumber(
  Document: TDocument
);
var IncomingDocument: TIncomingDocument;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  IncomingDocument := TIncomingDocument(Document);

  IncomingDocument.IncomingNumber := GenerateNewDocumentNumber(Document);

end;

constructor TStandardInDepartmentIncomingDocumentRegistrationService.Create(
  EmployeeFinder: IEmployeeFinder;
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry
);
begin

  inherited Create(DocumentNumeratorRegistry);

  FEmployeeFinder := EmployeeFinder;
  
end;

function TStandardInDepartmentIncomingDocumentRegistrationService.GetDocumentDate(
  Document: TDocument
): Variant;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  Result := (Document as TIncomingDocument).ReceiptDate;
  
end;

function TStandardInDepartmentIncomingDocumentRegistrationService.GetDocumentNumber(
  Document: TDocument
): String;
begin

  RaiseExceptionIfDocumentIsNotIncoming(Document);

  Result := (Document as TIncomingDocument).IncomingNumber;

end;

function TStandardInDepartmentIncomingDocumentRegistrationService.
  GetRegistrationDepartmentIdForDocument(Document: TDocument): Variant;

var
    IncomingDocument: TIncomingDocument;

    Receiver: TEmployee;
    FreeReceiver: IDomainObject;
begin

  IncomingDocument := Document as TIncomingDocument;

  RaiseExceptionIfIncomingDocumentReceiverIsNotSpecified(IncomingDocument);
  
  Receiver := FEmployeeFinder.FindEmployee(IncomingDocument.ReceiverId);

  FreeReceiver := Receiver;

  Result := Receiver.DepartmentIdentity;
  
end;

function TStandardInDepartmentIncomingDocumentRegistrationService.
  IsDocumentSelfRegistered(Document: TDocument): Boolean;
begin

  Result := False;
  
end;

procedure TStandardInDepartmentIncomingDocumentRegistrationService.
  RaiseExceptionIfDocumentIsNotIncoming(
    Document: TDocument
  );
begin

  if not (Document is TIncomingDocument) then begin

    raise TDocumentRegistrationServiceException.Create(
            'Обнаружена попытка ' +
            'регистрации НЕ входящего ' +
            'документа'
          );

  end;
  
end;

procedure TStandardInDepartmentIncomingDocumentRegistrationService.
  RaiseExceptionIfDocumentIsSelfRegistered(Document: TDocument);
begin

end;

procedure TStandardInDepartmentIncomingDocumentRegistrationService.
  RaiseExceptionIfIncomingDocumentReceiverIsNotSpecified(
    IncomingDocument: TIncomingDocument
  );
begin

  if VarIsNull(IncomingDocument.ReceiverId) then begin

    raise TDocumentRegistrationServiceException.Create(
      'Службой регистрации входящего документа ' +
      'не найдена информация о его получателе'
    );
    
  end;
  
end;

end.
