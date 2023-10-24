unit DocumentChargesSpecification;

interface

uses

  IDocumentUnit,
  Employee,
  InterfaceObjectList,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  SysUtils;

type

  IDocumentChargesSpecification = interface
    ['{2CF43036-B1F4-44B5-8415-C3EC9D2CDE7F}']
    
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

end.
