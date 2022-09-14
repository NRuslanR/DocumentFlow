unit AbstractDocumentRegistrationService;

interface

uses

  DocumentNumeratorRegistry,
  DocumentRegistrationService,
  IDocumentUnit,
  Document,
  StandardDocumentNumerator,
  DepartmentUnit,
  SysUtils,
  Classes;

type
  
  TAbstractDocumentRegistrationService =
    class (TInterfacedObject, IDocumentRegistrationService)

      protected

        FDocumentNumeratorRegistry: IDocumentNumeratorRegistry;

        function GetDocumentNumber(Document: TDocument): String; virtual;
        function GetDocumentDate(Document: TDocument): Variant; virtual;

      protected

         procedure RaiseExceptionIfDocumentAlreadyRegistered(
          Document: TDocument
        );

        procedure RaiseExceptionIfDocumentIsSelfRegistered(
          Document: TDocument
        ); virtual;

      protected

        procedure AssignNumber(Document: TDocument); virtual;
        procedure AssignDate(Document: TDocument); virtual;

        function IsNumberAssignedForDocument(Document: TDocument): Boolean;
        function IsDateAssignedForDocument(Document: TDocument): Boolean;

        function IsDocumentSelfRegistered(Document: TDocument): Boolean; virtual;
        
        function GenerateNewDocumentNumber(Document: TDocument): String; virtual; abstract;

      protected

        function AreDocumentRegistrationFieldsSet(Document: TDocument): Boolean; virtual;
        function AreDocumentRegistrationFieldsValid(Document: TDocument): Boolean; virtual;

      protected

        procedure InternalRegisterDocument(Document: TDocument); virtual;
        
      public

        constructor Create(DocumentNumeratorRegistry: IDocumentNumeratorRegistry);

        procedure RegisterDocument(Document: TDocument);

        procedure RegisterDocumentIfNecessary(Document: TDocument);
        
        function IsDocumentRegistered(Document: TDocument): Boolean;

    end;

implementation

uses

  PersonnelOrder,
  Variants,
  DateUtils;
  
{ TAbstractDocumentRegistrationService }

function TAbstractDocumentRegistrationService.AreDocumentRegistrationFieldsValid(
  Document: TDocument): Boolean;
begin

  Result := True;

end;

procedure TAbstractDocumentRegistrationService.AssignDate(Document: TDocument);
begin

  Document.DocumentDate := Now;
  
end;

procedure TAbstractDocumentRegistrationService.AssignNumber(
  Document: TDocument
);
begin

  Document.Number := GenerateNewDocumentNumber(Document);

end;

constructor TAbstractDocumentRegistrationService.Create(
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry
);
begin

  inherited Create;

  FDocumentNumeratorRegistry := DocumentNumeratorRegistry;
  
end;

function TAbstractDocumentRegistrationService.GetDocumentDate(
  Document: TDocument): Variant;
begin

  Result := Document.DocumentDate;
  
end;

function TAbstractDocumentRegistrationService.GetDocumentNumber(
  Document: TDocument): String;
begin

  Result := Document.Number;

end;

function TAbstractDocumentRegistrationService.IsDateAssignedForDocument(
  Document: TDocument
): Boolean;
var
    DocumentDate: Variant;
    DocumentYear, DocumentMonth, DocumentDay,
    DocumentHour, DocumentMinute, DocumentSecond, DocumentMilliSecond: Word;
begin

  DocumentDate := GetDocumentDate(Document);

  if VarIsNull(DocumentDate) then begin

    Result := False;
    Exit;
    
  end;
  
  DecodeDateTime(
    DocumentDate,
    DocumentYear, DocumentMonth, DocumentDay,
    DocumentHour, DocumentMinute, DocumentSecond, DocumentMilliSecond
  );

  Result :=

    IsValidDateTime(
      DocumentYear, DocumentMonth, DocumentDay,
      DocumentHour, DocumentMinute, DocumentSecond, DocumentMilliSecond
    );
    
end;

function TAbstractDocumentRegistrationService.
  IsDocumentRegistered(
    Document: TDocument
  ): Boolean;
begin

  Result :=
    AreDocumentRegistrationFieldsSet(Document)
    and (
      IsDocumentSelfRegistered(Document) or
      AreDocumentRegistrationFieldsValid(Document)
    );

end;

function TAbstractDocumentRegistrationService.IsDocumentSelfRegistered(
  Document: TDocument): Boolean;
begin

  Result := Document.IsSelfRegistered;
  
end;

function TAbstractDocumentRegistrationService.AreDocumentRegistrationFieldsSet(
  Document: TDocument): Boolean;
begin

  Result :=
    IsNumberAssignedForDocument(Document) and
    IsDateAssignedForDocument(Document);
    
end;

function TAbstractDocumentRegistrationService.IsNumberAssignedForDocument(
  Document: TDocument): Boolean;
begin

  Result := GetDocumentNumber(Document) <> '';
  
end;

procedure TAbstractDocumentRegistrationService.
  RaiseExceptionIfDocumentAlreadyRegistered(
    Document: TDocument
  );
begin

  if IsDocumentRegistered(Document) then begin

    raise TDocumentAlreadyRegisteredException.Create(
            Document,
            GetDocumentNumber(Document),
            GetDocumentDate(Document)
          );

  end;

end;

procedure TAbstractDocumentRegistrationService.RaiseExceptionIfDocumentIsSelfRegistered(
  Document: TDocument);
begin

  if
    Document.IsSelfRegistered
    and not IsNumberAssignedForDocument(Document)
  then begin

    raise TDocumentRegistrationServiceException.Create(
      'Для документа с выбранной опцией "Внесено с бумажной копии" ' +
      'номер необходимо указать вручную'
    );
    
  end;

end;

procedure TAbstractDocumentRegistrationService.RegisterDocumentIfNecessary(
  Document: TDocument);
begin

  if not IsDocumentRegistered(Document) then
    RegisterDocument(Document);
    
end;

procedure TAbstractDocumentRegistrationService.RegisterDocument(
  Document: TDocument
);
begin

  {
    refactor:
    create object which will check the registration's need for each document type
    and inject it to DocumentRegistrationService
  }

  if Document is TPersonnelOrder then Exit;

  InternalRegisterDocument(Document);
  
end;

procedure TAbstractDocumentRegistrationService.InternalRegisterDocument(
  Document: TDocument);
begin

  RaiseExceptionIfDocumentAlreadyRegistered(Document);
  RaiseExceptionIfDocumentIsSelfRegistered(Document);
  
  AssignNumber(Document);
  AssignDate(Document);
  
end;

end.
