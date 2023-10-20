unit StandardPersonnelOrderRepositoryRegistry;

interface

uses

  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderEmployeeList,
  PersonnelOrderSubKindEmployeeList,
  PersonnelOrderSubKindEmployeeGroup,
  RepositoryList,
  PersonnelOrderSubKindRepository,
  PersonnelOrderRepositoryRegistry,
  SysUtils;

type

  TStandardPersonnelOrderRepositoryRegistry =
    class (TInterfacedObject, IPersonnelOrderRepositoryRegistry)

      private

        FSingleEmployeeListRepositories: TRepositories;
        FSubKindEmployeeListRepositories: TRepositories;
        FSubKindEmployeeGroupRepositories: TRepositories;
        
        FPersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository;

      public

        destructor Destroy; override;
        constructor Create;
        
        procedure RegisterPersonnelOrderSignerListRepository(
          PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository
        );

        function GetPersonnelOrderSignerListRepository: IPersonnelOrderSingleEmployeeListRepository;

      public

        procedure RegisterPersonnelOrderApproverListRepository(
          PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
        );

        function GetPersonnelOrderApproverListRepository: IPersonnelOrderSubKindEmployeeListRepository;

      public

        procedure RegisterPersonnelOrderControlGroupRepository(
          PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository
        );

        function GetPersonnelOrderControlGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository;

      public

        procedure RegisterPersonnelOrderCreatingAccessEmployeeRepository(
          PersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository
        );

        function GetPersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository;

      public

        procedure RegisterPersonnelOrderSubKindRepository(
          PersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository
        );

        function GetPersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository;
        
    end;

implementation

uses

  PersonnelOrderSignerList,
  PersonnelOrderApproverList,
  PersonnelOrderControlGroup,
  PersonnelOrderCreatingAccessEmployeeList;

{ TStandardPersonnelOrderRepositoryRegistry }

constructor TStandardPersonnelOrderRepositoryRegistry.Create;
begin

  inherited;

  FSingleEmployeeListRepositories := TRepositories.Create;
  FSubKindEmployeeListRepositories := TRepositories.Create;
  FSubKindEmployeeGroupRepositories := TRepositories.Create;

end;

destructor TStandardPersonnelOrderRepositoryRegistry.Destroy;
begin

  FreeAndNil(FSingleEmployeeListRepositories);
  FreeAndNil(FSubKindEmployeeListRepositories);
  FreeAndNil(FSubKindEmployeeGroupRepositories);

  inherited;

end;

function TStandardPersonnelOrderRepositoryRegistry.
  GetPersonnelOrderSignerListRepository: IPersonnelOrderSingleEmployeeListRepository;
begin

  Result :=
    IPersonnelOrderSingleEmployeeListRepository(
      FSingleEmployeeListRepositories[TPersonnelOrderSignerList]
    );
    
end;

function TStandardPersonnelOrderRepositoryRegistry.GetPersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository;
begin

  Result := FPersonnelOrderSubKindRepository;
  
end;

function TStandardPersonnelOrderRepositoryRegistry.
  GetPersonnelOrderControlGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository;
begin

  Result :=
    IPersonnelOrderSubKindEmployeeGroupRepository(
      FSubKindEmployeeGroupRepositories[TPersonnelOrderControlGroup]
    );

end;

function TStandardPersonnelOrderRepositoryRegistry.
  GetPersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository;
begin

  Result :=
    IPersonnelOrderSingleEmployeeListRepository(
      FSingleEmployeeListRepositories[TPersonnelOrderCreatingAccessEmployeeList]
    );

end;

function TStandardPersonnelOrderRepositoryRegistry.GetPersonnelOrderApproverListRepository: IPersonnelOrderSubKindEmployeeListRepository;
begin

  Result :=
    IPersonnelOrderSubKindEmployeeListRepository(
      FSubKindEmployeeListRepositories[TPersonnelOrderApproverList]
    );
    
end;

procedure TStandardPersonnelOrderRepositoryRegistry.RegisterPersonnelOrderSignerListRepository(
  PersonnelOrderSingleEmployeeListRepository: IPersonnelOrderSingleEmployeeListRepository
);
begin

  FSingleEmployeeListRepositories.AddOrUpdateRepository(
    TPersonnelOrderSignerList, PersonnelOrderSingleEmployeeListRepository
  );
  
end;

procedure TStandardPersonnelOrderRepositoryRegistry.RegisterPersonnelOrderSubKindRepository(
  PersonnelOrderSubKindRepository: IPersonnelOrderSubKindRepository);
begin

  FPersonnelOrderSubKindRepository := PersonnelOrderSubKindRepository;

end;

procedure TStandardPersonnelOrderRepositoryRegistry.RegisterPersonnelOrderControlGroupRepository(
  PersonnelOrderSubKindEmployeeGroupRepository: IPersonnelOrderSubKindEmployeeGroupRepository);
begin

  FSubKindEmployeeGroupRepositories.AddOrUpdateRepository(
    TPersonnelOrderControlGroup, PersonnelOrderSubKindEmployeeGroupRepository
  );
  
end;

procedure TStandardPersonnelOrderRepositoryRegistry.RegisterPersonnelOrderCreatingAccessEmployeeRepository(
  PersonnelOrderCreatingAccessEmployeeRepository: IPersonnelOrderSingleEmployeeListRepository);
begin

  FSingleEmployeeListRepositories[TPersonnelOrderCreatingAccessEmployeeList] :=
    PersonnelOrderCreatingAccessEmployeeRepository;

end;

procedure TStandardPersonnelOrderRepositoryRegistry.RegisterPersonnelOrderApproverListRepository(
  PersonnelOrderSubKindEmployeeListRepository: IPersonnelOrderSubKindEmployeeListRepository
);
begin

  FSubKindEmployeeListRepositories.AddOrUpdateRepository(
    TPersonnelOrderApproverList, PersonnelOrderSubKindEmployeeListRepository
  );
  
end;

end.
