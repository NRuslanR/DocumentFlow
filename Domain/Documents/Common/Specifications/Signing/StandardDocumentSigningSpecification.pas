unit StandardDocumentSigningSpecification;

interface

uses

  DocumentSigningSpecification,
  IDocumentUnit,
  Employee,
  Document,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DomainException,
  SysUtils;

type

  TStandardDocumentSigningSpecification =
    class (TInterfacedObject, IDocumentSigningSpecification)

      protected

        FEmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;

      public

        constructor Create(
          EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
        );
        
        function IsEmployeeAnyOfDocumentSigners(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; overload;

        function IsEmployeeAnyOfDocumentSigners(
          Employee: TEmployee;
          Document: IDocument;
          var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
        ): Boolean; overload;

        function IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; overload;

        function IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument;
          var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
        ): Boolean; overload;

        function IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual; 

    end;

implementation

uses

  Disposable,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

{ TStandardDocumentSigningSpecification }

constructor TStandardDocumentSigningSpecification.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification);
begin

  inherited Create;

  FEmployeeIsSameAsOrReplacingForOthersSpecification := EmployeeIsSameAsOrReplacingForOthersSpecification;
  
end;

function TStandardDocumentSigningSpecification.IsEmployeeAnyOfDocumentSigners(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    FreeSpecificationResult: IDisposable;
begin

  Result := IsEmployeeAnyOfDocumentSigners(Employee, Document, SpecificationResult);

  FreeSpecificationResult := SpecificationResult;

end;

function TStandardDocumentSigningSpecification.IsEmployeeAnyOfDocumentSigners(
  Employee: TEmployee;
  Document: IDocument;
  var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
): Boolean;
var
    DocumentSigners: TEmployees;
    FreeDocumentSigners: IDomainObjectBaseList;
begin

  if Document.Signings.IsEmpty then begin

    SpecificationResult := TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.Create;

    Result := False;
    
    Exit;
    
  end;

  DocumentSigners := Document.FetchAllSigners;

  FreeDocumentSigners := DocumentSigners;

  SpecificationResult :=
    FEmployeeIsSameAsOrReplacingForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Employee, DocumentSigners
      );

  Result := SpecificationResult.IsSatisfied;

end;

function TStandardDocumentSigningSpecification.IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
  Employee: TEmployee; Document: IDocument): Boolean;
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    Free: IDisposable;
begin

  Result := IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(Employee, Document, SpecificationResult);

  Free := SpecificationResult;
  
end;

function TStandardDocumentSigningSpecification.IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
  Employee: TEmployee;
  Document: IDocument;
  var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
): Boolean;
begin

  Result := IsEmployeeAnyOfDocumentSigners(Employee, Document, SpecificationResult);

  if not Result then begin

    Result := IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(Employee, Document)

  end;

end;

function TStandardDocumentSigningSpecification.IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(
  Employee: TEmployee; Document: IDocument): Boolean;
begin

  Result := False;
  
end;

end.
