unit PersonnelOrderApproverSetReadService;

interface

uses

  PersonnelOrderSubKindEmployeeSetReadService,
  EmployeeSetHolder,
  SysUtils;

type

  IPersonnelOrderApproverSetReadService = interface (IPersonnelOrderSubKindEmployeeSetReadService)

    function GetApproverSetForPersonnelOrderSubKind(
      const PersonnelOrderSubKindId: Variant
    ): TEmployeeSetHolder;
    
  end;
  
implementation

end.
