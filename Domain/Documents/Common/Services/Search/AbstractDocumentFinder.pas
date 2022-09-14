unit AbstractDocumentFinder;

interface

uses

  DocumentFinder,
  VariantListUnit,
  IDocumentUnit,
  DocumentChargeInterface,
  Document,
  SysUtils,
  Classes;

type

  TAbstractDocumentFinder = class (TInterfacedObject, IDocumentFinder)

    protected

      function InternalFindDocumentsByNumbers(const Numbers: TStrings): TDocuments; virtual; abstract;

      function InternalFindDocumentsByNumberAndCreationYear(
        const Number: String;
        const CreationYear: Integer
      ): TDocuments; virtual; abstract;

      function InternalFindDocumentsByNumbersAndCreationYear(
        const Numbers: TStrings;
        const CreationYear: Integer
      ): TDocuments; virtual; abstract;
      
      function InternalFindDocumentById(const DocumentId: Variant): IDocument; virtual; abstract;
      function InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; virtual; abstract;

    protected

      procedure AssignWorkingRulesAndSpecifications(Documents: TDocuments); overload;
      procedure AssignWorkingRulesAndSpecifications(Document: TDocument); overload;
      procedure AssignWorkingRulesToDocument(Document: TDocument);
      procedure AssignSpecificationsToDocument(Document: TDocument);

    protected

      procedure AssignWorkingRulesToDocumentCharges(Charges: IDocumentCharges);
      
    public

      function GetSelf: TObject;
      
      function FindDocumentsByNumber(const Number: String): TDocuments;
      function FindDocumentsByNumbers(const Numbers: TStrings): TDocuments;

      function FindDocumentsByNumberAndCreationYear(
        const Number: String;
        const CreationYear: Integer
      ): TDocuments;

      function FindDocumentsByNumbersAndCreationYear(
        const Numbers: TStrings;
        const CreationYear: Integer
      ): TDocuments;

      function FindDocumentById(const DocumentId: Variant): IDocument;
      function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;

  end;

implementation

uses

  ArrayFunctions,
  DocumentCharges,
  DocumentRuleRegistry,
  DocumentChargeRuleRegistry,
  DocumentSpecificationRegistry;


{ TAbstractDocumentFinder }

function TAbstractDocumentFinder.FindDocumentById(
  const DocumentId: Variant
): IDocument;
begin

  Result := InternalFindDocumentById(DocumentId);

  if Assigned(Result) then
    AssignWorkingRulesAndSpecifications(TDocument(Result.Self));
    
end;

function TAbstractDocumentFinder.FindDocumentsByNumber(
  const Number: String): TDocuments;
var
    DocumentNumbers: TStrings;
begin

  DocumentNumbers := StringArrayToStrings([Number]);

  try

    Result := FindDocumentsByNumbers(DocumentNumbers);

  finally

    FreeAndNil(DocumentNumbers);
    
  end;

end;

function TAbstractDocumentFinder
  .FindDocumentsByNumberAndCreationYear(
    const Number: String;
    const CreationYear: Integer
  ): TDocuments;
begin

  Result := InternalFindDocumentsByNumberAndCreationYear(Number, CreationYear);

  if Assigned(Result) then
    AssignWorkingRulesAndSpecifications(Result);
    
end;

function TAbstractDocumentFinder
  .FindDocumentsByNumbersAndCreationYear(
    const Numbers: TStrings;
    const CreationYear: Integer
  ): TDocuments;
begin

  Result := InternalFindDocumentsByNumbersAndCreationYear(Numbers, CreationYear);

  if Assigned(Result) then
    AssignWorkingRulesAndSpecifications(Result);

end;

function TAbstractDocumentFinder.FindDocumentsByNumbers(
  const Numbers: TStrings): TDocuments;
begin

  Result := InternalFindDocumentsByNumbers(Numbers);

  if Assigned(Result) then
    AssignWorkingRulesAndSpecifications(Result);
    
end;

function TAbstractDocumentFinder.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TAbstractDocumentFinder.FindDocumentsByIds(
  const DocumentIds: TVariantList
): TDocuments;
var
    Document: TDocument;
begin

  Result := InternalFindDocumentsByIds(DocumentIds);

  if not Assigned(Result) then Exit;

  for Document in Result do
    AssignWorkingRulesAndSpecifications(Document);

end;

procedure TAbstractDocumentFinder.AssignWorkingRulesAndSpecifications(
  Documents: TDocuments);
var
    Document: TDocument;
begin

  for Document in Documents do
    AssignWorkingRulesAndSpecifications(Document);

end;

procedure TAbstractDocumentFinder.AssignWorkingRulesAndSpecifications(
  Document: TDocument);
begin

  AssignWorkingRulesToDocument(Document);
  AssignSpecificationsToDocument(Document);
  
end;

procedure TAbstractDocumentFinder.AssignWorkingRulesToDocument(
  Document: TDocument);
begin

  Document.WorkingRules :=
    TDocumentRuleRegistry
      .GetEmployeeDocumentWorkingRules(Document.ClassType);

  AssignWorkingRulesToDocumentCharges(Document.Charges);
  
end;

procedure TAbstractDocumentFinder.AssignSpecificationsToDocument(
  Document: TDocument);
begin

  Document.Specifications :=
    TDocumentSpecificationRegistry.Instance.GetDocumentSpecifications(
      Document.ClassType
    );

end;

procedure TAbstractDocumentFinder.AssignWorkingRulesToDocumentCharges(
  Charges: IDocumentCharges);
var
    Charge: IDocumentCharge;
    ChargeObj: TDocumentCharge;
begin

  if not Assigned(Charges) then Exit;
  
  for Charge in Charges do begin

    ChargeObj := TDocumentCharge(Charge.Self);

    ChargeObj.WorkingRules :=
      TDocumentChargeRuleRegistry.Instance.GetDocumentChargeWorkingRules(
        ChargeObj.ClassType
      );

  end;

end;

end.
