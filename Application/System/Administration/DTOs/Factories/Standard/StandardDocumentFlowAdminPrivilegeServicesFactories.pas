unit StandardDocumentFlowAdminPrivilegeServicesFactories;

interface

uses

  DocumentFlowAdminPrivilegeServicesFactories,
  DocumentFlowAdminPrivileges,
  StandardDocumentsAdminPrivilegeServicesFactory,
  BasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory,
  BasedOnVclZeosEmployeesAdminPrivilegeServicesFactory,
  BasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory,
  BasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory,
  BasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory,
  BasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory,
  BasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory,
  BasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory,
  BasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory,
  BasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory,
  BasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivilegeServicesFactory,
  DocumentKindResolver,
  ZConnection,
  SysUtils;

type

  TStandardDocumentFlowAdminPrivilegeServicesFactories =
    class (TInterfacedObject, IDocumentFlowAdminPrivilegeServicesFactories)

      private

        FDocumentKindResolver: IDocumentKindResolver;
        FZConnection: TZConnection;
        
      public

        constructor Create(
          DocumentKindResolver: IDocumentKindResolver;
          ZConnection: TZConnection
        );

        function CreateDocumentsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateDocumentNumeratorsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateEmployeesAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateEmployeesReplacementsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateEmployeesWorkGroupsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateEmpoyeeStaffsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateDepartmentsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreateSynchronizationDataAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

      public

        function CreatePersonnelOrderEmployeesAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreatePersonnelOrderControlGroupsAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreatePersonnelOrderKindApproversAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

        function CreatePersonnelOrderSignersAdminPrivilegeServicesFactory(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        ): IDocumentFlowAdminPrivilegeServicesFactory;

    end;

implementation

{ TStandardDocumentFlowAdminPrivilegeServicesFactories }

constructor TStandardDocumentFlowAdminPrivilegeServicesFactories.Create(
  DocumentKindResolver: IDocumentKindResolver;
  ZConnection: TZConnection
);
begin

  inherited Create;

  FDocumentKindResolver := DocumentKindResolver;
  FZConnection := ZConnection;

end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateDocumentNumeratorsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosDocumentNumeratorsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateDocumentsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TStandardDocumentsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FDocumentKindResolver
    );

end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateDepartmentsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosDepartmentsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateEmployeesReplacementsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosEmployeesReplacementsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateEmployeesAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosEmployeesAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateEmployeesWorkGroupsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin


  Result :=
    TBasedOnVclZeosEmployeesWorkGroupsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateEmpoyeeStaffsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosEmployeeStaffsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreatePersonnelOrderControlGroupsAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosPersonnelOrderControlGroupsAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );

end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreatePersonnelOrderEmployeesAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosPersonnelOrderEmployeesAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );

end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreatePersonnelOrderKindApproversAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosPersonnelOrderKindApproversAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreatePersonnelOrderSignersAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosPersonnelOrderSignersAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

function TStandardDocumentFlowAdminPrivilegeServicesFactories.
  CreateSynchronizationDataAdminPrivilegeServicesFactory(
    const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
  ): IDocumentFlowAdminPrivilegeServicesFactory;
begin

  Result :=
    TBasedOnVclZeosSynchronizationDataAdminPrivilegeServicesFactory.Create(
      DocumentFlowAdminPrivilege,
      FZConnection
    );
    
end;

end.
