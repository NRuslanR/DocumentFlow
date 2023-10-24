unit StandardDocumentChargesSpecification;

interface

uses

  DocumentChargesSpecification,
  IDocumentUnit,
  Employee,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  InterfaceObjectList,
  SysUtils;

type

  TStandardDocumentChargesSpecification =
    class (TInterfacedObject, IDocumentChargesSpecification)

      protected

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;
          
      public

        constructor Create(
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification
        );
        
        function IsDocumentChargeAssignedForEmployee(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; overload;

        function IsDocumentChargeAssignedForEmployee(
          Employee: TEmployee;
          Document: IDocument;
          var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
        ): Boolean; overload;
        
    end;
  
implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  Disposable;
  
{ TStandardDocumentChargesSpecification }

constructor TStandardDocumentChargesSpecification.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification);
begin

  inherited Create;

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;
  
end;

function TStandardDocumentChargesSpecification.IsDocumentChargeAssignedForEmployee(
  Employee: TEmployee; Document: IDocument): Boolean;
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    FreeSpecificationResult: IDisposable;
begin

  Result := IsDocumentChargeAssignedForEmployee(Employee, Document, SpecificationResult);
  
  FreeSpecificationResult := SpecificationResult;

end;

function TStandardDocumentChargesSpecification.IsDocumentChargeAssignedForEmployee(
  Employee: TEmployee;
  Document: IDocument;
  var SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult
): Boolean;
var
    DocumentPerformers: TEmployees;
    FreeDocumentPerformers: IDomainObjectBaseList;
begin

  if Document.Charges.IsEmpty then begin

    SpecificationResult := TEmployeeIsSameAsOrReplacingForOthersSpecificationResult.Create;

    Result := False;

    Exit;
    
  end;
  
  DocumentPerformers := Document.FetchAllPerformers;

  FreeDocumentPerformers := DocumentPerformers;

  SpecificationResult :=
    FEmployeeIsSameAsOrReplacingForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Employee, DocumentPerformers
      );

  Result := SpecificationResult.IsSatisfied;

end;

end.
