unit DocumentSigningSpecification;

interface

uses

  IDocumentUnit,
  Employee,
  DomainException,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  SysUtils;

type

  TDocumentSigningSpecificationException = class (TDomainException)

  end;
  
  IDocumentSigningSpecification = interface
    ['{80E4D038-2CBE-479D-93F5-825B8998CA54}']

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
    ): Boolean;

  end;

implementation

end.
