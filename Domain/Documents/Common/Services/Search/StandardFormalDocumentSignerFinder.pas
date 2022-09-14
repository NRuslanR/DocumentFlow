unit StandardFormalDocumentSignerFinder;

interface

uses

  Document,
  Employee,
  DepartmentUnit,
  FormalDocumentSignerFinder,
  DepartmentFinder,
  EmployeeFinder,
  DocumentNumeratorRegistry,
  IDocumentUnit,
  DocumentNumerator,
  StandardDocumentNumerator,
  SysUtils,
  Classes;

type

  TStandardFormalDocumentSignerFinder = class (TInterfacedObject, IFormalDocumentSignerFinder)

    protected

      FDocumentNumeratorRegistry: IDocumentNumeratorRegistry;
      FEmployeeFinder: IEmployeeFinder;

      function GetFormalSignerByDocumentNumber(Document: IDocument): TEmployee;
      
    public

      constructor Create(
        DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
        EmployeeFinder: IEmployeeFinder
      );

      function GetFormalDocumentSigner(Document: IDocument): TEmployee;

  end;

implementation

uses

  AuxiliaryStringFunctions,
  IDomainObjectBaseUnit;

{ TStandardFormalDocumentSignerFinder }

constructor TStandardFormalDocumentSignerFinder.Create(
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
  EmployeeFinder: IEmployeeFinder
);
begin

  inherited Create;

  FDocumentNumeratorRegistry := DocumentNumeratorRegistry;
  FEmployeeFinder := EmployeeFinder;
  
end;

function TStandardFormalDocumentSignerFinder.GetFormalDocumentSigner(
  Document: IDocument
): TEmployee;
begin

  if Document.Signings.IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  if not Document.IsSelfRegistered then
    Result := Document.Signings.First.Signer

  else
    Result := GetFormalSignerByDocumentNumber(Document);

end;

function TStandardFormalDocumentSignerFinder.GetFormalSignerByDocumentNumber(
  Document: IDocument
): TEmployee;
var
    DocumentNumerator: TDocumentNumerator;
    FreeDocumentNumerator: IDocumentNumerator;

    FormalSignerDepartmentCode: String;
    FormalSignerDepartment: TDepartment;
    FreeFormalSignerDepartment: IDomainObjectBase;
begin

  DocumentNumerator :=
    FDocumentNumeratorRegistry.GetDocumentNumeratorFor(
      TDocument(Document.Self).ClassType, Document.Signings.First.Signer.DepartmentIdentity
    );

  FreeDocumentNumerator := DocumentNumerator;

  if DocumentNumerator.NumberConstantParts.Prefix = '' then begin

    Result := nil;
    Exit;
    
  end;

  FormalSignerDepartmentCode :=
    LeftByLastDelimiter(
      Document.Number,
      DocumentNumerator.NumberConstantParts.Delimiter
    );

  Result := FEmployeeFinder.FindLeaderByDepartmentCode(FormalSignerDepartmentCode);


end;

end.
