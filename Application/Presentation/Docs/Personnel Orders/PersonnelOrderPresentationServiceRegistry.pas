unit PersonnelOrderPresentationServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  PersonnelOrderApproverSetReadService,
  PersonnelOrderSignerSetReadService,
  PersonnelOrderSubKindSetReadService,
  SysUtils;

type

  TPersonnelOrderPresentationServiceRegistry = class (TApplicationServiceRegistry)

    public

      procedure RegisterPersonnelOrderApproverSetReadService(
        PersonnelOrderApproverSetReadService: IPersonnelOrderApproverSetReadService
      );

      function GetPersonnelOrderApproverSetReadService: IPersonnelOrderApproverSetReadService;

    public

      procedure RegisterPersonnelOrderSignerSetReadService(
        PersonnelOrderSignerSetReadService: IPersonnelOrderSignerSetReadService
      );

      function GetPersonnelOrderSignerSetReadService: IPersonnelOrderSignerSetReadService;

    public

      procedure RegisterPersonnelOrderSubKindSetReadService(
        PersonnelOrderSubKindSetReadService: IPersonnelOrderSubKindSetReadService
      );

      function GetPersonnelOrderSubKindSetReadService: IPersonnelOrderSubKindSetReadService;

  end;

  
implementation

type

  TPersonnelOrderApproverSetReadServiceType = class

  end;
  
  TPersonnelOrderSignerSetReadServiceType = class

  end;

  TPersonnelOrderSubKindSetReadServiceType = class
  
  end;

{ TPersonnelOrderPresentationServiceRegistry }

function TPersonnelOrderPresentationServiceRegistry.
  GetPersonnelOrderApproverSetReadService: IPersonnelOrderApproverSetReadService;
begin

  Result :=
    IPersonnelOrderApproverSetReadService(
      GetApplicationService(TPersonnelOrderApproverSetReadServiceType)
    );
    
end;

function TPersonnelOrderPresentationServiceRegistry.
  GetPersonnelOrderSignerSetReadService: IPersonnelOrderSignerSetReadService;
begin

  Result :=
    IPersonnelOrderSignerSetReadService(
      GetApplicationService(TPersonnelOrderSignerSetReadServiceType)
    );
    
end;

function TPersonnelOrderPresentationServiceRegistry.
  GetPersonnelOrderSubKindSetReadService: IPersonnelOrderSubKindSetReadService;
begin

  Result :=
    IPersonnelOrderSubKindSetReadService(
      GetApplicationService(TPersonnelOrderSubKindSetReadServiceType)
    );

end;

procedure TPersonnelOrderPresentationServiceRegistry.
  RegisterPersonnelOrderApproverSetReadService(
    PersonnelOrderApproverSetReadService: IPersonnelOrderApproverSetReadService
  );
begin

  RegisterApplicationService(
    TPersonnelOrderApproverSetReadServiceType,
    PersonnelOrderApproverSetReadService
  );

end;

procedure TPersonnelOrderPresentationServiceRegistry.
  RegisterPersonnelOrderSignerSetReadService(
    PersonnelOrderSignerSetReadService: IPersonnelOrderSignerSetReadService
  );
begin

  RegisterApplicationService(
    TPersonnelOrderSignerSetReadServiceType,
    PersonnelOrderSignerSetReadService
  );
  
end;

procedure TPersonnelOrderPresentationServiceRegistry.RegisterPersonnelOrderSubKindSetReadService(
  PersonnelOrderSubKindSetReadService: IPersonnelOrderSubKindSetReadService);
begin

  RegisterApplicationService(
    TPersonnelOrderSubKindSetReadServiceType,
    PersonnelOrderSubKindSetReadService
  );
  
end;

end.
