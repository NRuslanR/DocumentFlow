unit StandardPersonnelOrderApproverSetReadService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderApproverSetReadService,
  PersonnelOrderApproverListFinder,
  AbstractPersonnelOrderSubKindEmployeeSetReadService,
  EmployeeSetReadService,
  EmployeeSetHolder,
  SysUtils;

type

  TStandardPersonnelOrderApproverSetReadService =
    class (
      TAbstractPersonnelOrderSubKindEmployeeSetReadService,
      IPersonnelOrderApproverSetReadService
    )

      public

        constructor Create(
          PersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder;
          EmployeeSetReadService: IEmployeeSetReadService
        );

        function GetApproverSetForPersonnelOrderSubKind(
          const PersonnelOrderSubKindId: Variant
        ): TEmployeeSetHolder;
      
    end;

  
implementation

uses

  PersonnelOrderApproverList,
  IDomainObjectBaseListUnit,
  IDomainObjectBaseUnit;

{ TStandardPersonnelOrderApproverSetReadService }

constructor TStandardPersonnelOrderApproverSetReadService.Create(
  PersonnelOrderApproverListFinder: IPersonnelOrderApproverListFinder;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create(PersonnelOrderApproverListFinder, EmployeeSetReadService);

end;

function TStandardPersonnelOrderApproverSetReadService.
  GetApproverSetForPersonnelOrderSubKind(
    const PersonnelOrderSubKindId: Variant
  ): TEmployeeSetHolder;
begin

  Result := GetEmployeeSetForPersonnelOrderSubKind(PersonnelOrderSubKindId);

end;

end.
