unit StandardInDepartmentDocumentRegistrationService;

interface

uses

  AbstractDocumentRegistrationService,
  SysUtils,
  Classes,
  Document,
  DocumentNumeratorRegistry,
  DocumentRegistrationService,
  StandardDocumentNumerator,
  DepartmentFinder,
  Department;

type

  TStandardInDepartmentDocumentRegistrationService =
    class (TAbstractDocumentRegistrationService)

      protected

        FDocumentSignerDepartmentId: Variant;
        FDocumentNumerator: TDocumentNumerator;

      protected

        function GetRegistrationDepartmentIdForDocument(Document: TDocument): Variant; virtual;

        function GetDocumentSignerDepartmentId(Document: TDocument): Variant;

        function GetDocumentNumeratorFor(
          Document: TDocument;
         const DocumentSignerDepartmentId: Variant
        ): TDocumentNumerator;
        
      protected

        function GenerateNewDocumentNumber(Document: TDocument): String; override;

      protected

        procedure RaiseDocumentRegistrationExceptionIfDocumentSignerCountIsNotValid(
          Document: TDocument
        );

        procedure RaiseDocumentRegistrationValidationExceptionIfSignerCountIsNotValid(
          Document: TDocument
        );

      protected

        function IsDocumentNumberContainsDepartmentCode(
          Document: TDocument;
          const DepartmentId: Variant
        ): Boolean;

        function AreDocumentRegistrationFieldsValid(Document: TDocument): Boolean; override;
        
      public

        constructor Create(
          DocumentNumeratorRegistry: IDocumentNumeratorRegistry
        );

        procedure InternalRegisterDocument(Document: TDocument); override;
        
    end;

implementation

uses

  StrUtils,
  AuxiliaryStringFunctions,
  Variants,
  IDomainObjectUnit,
  IDomainObjectListUnit,
  DocumentSignings,
  Employee;

{ TStandardInDepartmentDocumentRegistrationService }

constructor TStandardInDepartmentDocumentRegistrationService.Create(
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry
);
begin

  inherited Create(DocumentNumeratorRegistry);

  FDocumentSignerDepartmentId := Null;
  
end;

function TStandardInDepartmentDocumentRegistrationService.
  GenerateNewDocumentNumber(Document: TDocument): String;
begin

  Result := FDocumentNumerator.CreateNewDocumentNumber;

end;

function TStandardInDepartmentDocumentRegistrationService.
  IsDocumentNumberContainsDepartmentCode(
    Document: TDocument;
    const DepartmentId: Variant
  ): Boolean;
var DocumentNumerator: TDocumentNumerator;
    DocumentNumberDepartmentCode: String;
begin

  if Assigned(FDocumentNumerator) then
    DocumentNumerator := FDocumentNumerator

  else begin
  
    DocumentNumerator :=
      FDocumentNumeratorRegistry.GetDocumentNumeratorFor(
        Document.ClassType, DepartmentId
      );

  end;

  DocumentNumberDepartmentCode :=
     LeftByLastDelimiter(
      Document.Number,
      DocumentNumerator.NumberConstantParts.Delimiter
     );

  if DocumentNumberDepartmentCode = '' then begin

    Result := False;
    Exit;
    
  end;

  Result :=
    Trim(DocumentNumberDepartmentCode) =
    DocumentNumerator.NumberConstantParts.Prefix;

end;

function TStandardInDepartmentDocumentRegistrationService.AreDocumentRegistrationFieldsValid(
  Document: TDocument
): Boolean;

var
   DocumentSignerDepartmentId: Variant;
begin

  { На данный момент заменять префикс номера документа на действительный
    код подразделения подписанта в случае его некорректности нет необходимости

  if not VarIsNull(FDocumentSignerDepartmentId) then
    DocumentSignerDepartmentId := FDocumentSignerDepartmentId

  else begin                                         

    RaiseDocumentRegistrationValidationExceptionIfSignerCountIsNotValid(Document);
    
    DocumentSignerDepartmentId := GetDocumentSignerDepartmentId(Document);

  end;   }

  Result :=
    inherited AreDocumentRegistrationFieldsValid(Document)
    {and IsDocumentNumberContainsDepartmentCode(Document, DocumentSignerDepartmentId)}
    ;
    
end;

procedure TStandardInDepartmentDocumentRegistrationService.InternalRegisterDocument(
  Document: TDocument
);
var
    DocumentSigners: TEmployees;
    FreeList: IDomainObjectList;
begin

  RaiseDocumentRegistrationExceptionIfDocumentSignerCountIsNotValid(Document);

  FDocumentSignerDepartmentId := Null;
  FDocumentNumerator := nil;

  FDocumentSignerDepartmentId := GetRegistrationDepartmentIdForDocument(Document);
  FDocumentNumerator := GetDocumentNumeratorFor(Document, FDocumentSignerDepartmentId);

  try

    inherited InternalRegisterDocument(Document);
    
  finally

    FDocumentSignerDepartmentId := Null;
    FDocumentNumerator := nil;

  end;

end;

procedure TStandardInDepartmentDocumentRegistrationService.
  RaiseDocumentRegistrationExceptionIfDocumentSignerCountIsNotValid(
    Document: TDocument
  );
var
    DocumentSigners: TEmployees;
    Free: IDomainObjectList;
begin

  DocumentSigners := Document.FetchAllSigners;

  Free := DocumentSigners;

  if not Assigned(DocumentSigners) or DocumentSigners.IsEmpty then begin

    raise TDocumentRegistrationServiceException.Create(
      'Для регистрации документа требуется ' +
      'наличие информации о его подписанте'
    );

  end

end;

procedure TStandardInDepartmentDocumentRegistrationService.
  RaiseDocumentRegistrationValidationExceptionIfSignerCountIsNotValid(
    Document: TDocument
  );
var
    DocumentSigners: TEmployees;
    Free: IDomainObjectList;
begin

  DocumentSigners := Document.FetchAllSigners;

  Free := DocumentSigners;

  if not Assigned(DocumentSigners) or DocumentSigners.IsEmpty then begin

    raise TDocumentRegistrationServiceException.Create(
      'Во время проверки факта регистрации документа ' +
      'не была найдена информации о его подписанте'
    );

  end;

end;

function TStandardInDepartmentDocumentRegistrationService.GetDocumentNumeratorFor(
  Document: TDocument;
 const DocumentSignerDepartmentId: Variant
): TDocumentNumerator;
begin

  Result :=
    FDocumentNumeratorRegistry.GetDocumentNumeratorFor(
      Document.ClassType, DocumentSignerDepartmentId
    );

end;

function TStandardInDepartmentDocumentRegistrationService.
  GetDocumentSignerDepartmentId(Document: TDocument): Variant;
var
    DocumentSigners: TEmployees;
    FreeList: IDomainObjectList;
begin

  DocumentSigners := Document.FetchAllSigners;

  FreeList := DocumentSigners;

  Result := DocumentSigners[0].DepartmentIdentity;
    
end;

function TStandardInDepartmentDocumentRegistrationService.
  GetRegistrationDepartmentIdForDocument(
    Document: TDocument
  ): Variant;
begin

  Result := GetDocumentSignerDepartmentId(Document);
  
end;

end.
