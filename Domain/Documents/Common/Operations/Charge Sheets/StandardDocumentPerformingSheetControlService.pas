unit StandardDocumentPerformingSheetControlService;

interface

uses

  DocumentChargeSheetControlService,
  StandardDocumentChargeSheetControlService,
  Document,
  IDocumentUnit,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentPerformingSheet,
  DocumentChargeInterface,
  DocumentDirectory,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  EmployeeSubordinationService,
  EmployeeDocumentChargeSheetWorkingRules,
  DocumentChargeSheetOverlappingPerformingService,
  DocumentChargeSheetCreatingService,
  EmployeeChargeIssuingRule,
  DepartmentEmployeeDistributionSpecification,
  DocumentPerformingService,
  DomainObjectValueUnit,
  IDomainObjectBaseUnit,
  Employee,
  SysUtils;

type

  TStandardDocumentPerformingSheetControlService =
    class (TStandardDocumentChargeSheetControlService)

      protected

        FDocumentChargeSheetOverlappingPerformingService:
          IDocumentChargeSheetOverlappingPerformingService;

      protected

        function DoPerformingChargeSheet(
          Employee: TEmployee;
          ChargeSheet: TDocumentChargeSheet
        ): TChargeSheetPerformingResult; override;

      public

        constructor Create(

          DocumentDirectory: IDocumentDirectory;

          DocumentChargeSheetOverlappingPerformingService:
            IDocumentChargeSheetOverlappingPerformingService;

          DocumentPerformingService: IDocumentPerformingService;

          DocumentChargeSheetCreatingService: IDocumentChargeSheetCreatingService;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification
            
        );

    end;

implementation

{ TStandardDocumentPerformingSheetControlService }

constructor TStandardDocumentPerformingSheetControlService.Create(
  DocumentDirectory: IDocumentDirectory;
  DocumentChargeSheetOverlappingPerformingService: IDocumentChargeSheetOverlappingPerformingService;
  DocumentPerformingService: IDocumentPerformingService;
  DocumentChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification
);
begin

  inherited Create(
    DocumentDirectory,
    DocumentPerformingService,
    DocumentChargeSheetCreatingService,
    EmployeeIsSameAsOrReplacingForOthersSpecification
  );

  FDocumentChargeSheetOverlappingPerformingService :=
    DocumentChargeSheetOverlappingPerformingService;

end;

function TStandardDocumentPerformingSheetControlService.DoPerformingChargeSheet(

  Employee: TEmployee;
  ChargeSheet: TDocumentChargeSheet

): TChargeSheetPerformingResult;
var
    PerformedChargeSheets: IDocumentChargeSheets;
begin

  PerformedChargeSheets :=
    FDocumentChargeSheetOverlappingPerformingService.
      PerformChargeSheetAsOverlapping(
        ChargeSheet,
        Employee
      );

  Result := TChargeSheetPerformingResult.Create(PerformedChargeSheets);

end;

end.
