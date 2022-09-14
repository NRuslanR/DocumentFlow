unit StandardDocumentFlowAdministrationService;

interface

uses

  AbstractApplicationService,
  DocumentFlowAdministrationService,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeServices,
  SystemAdministrationPrivileges,
  SystemAdministrationPrivilegeServices,
  DocumentFlowAuthorizationService,
  NativeDocumentKindsReadService,
  NativeDocumentKindDto,
  DocumentFlowAdminPrivilegeServicesFactories,
  DocumentFlowAdminPrivilegeServicesFactory,
  DocumentKindDto,
  Hashes,
  SysUtils,
  Classes;

type

  TStandardDocumentFlowAdministrationService =
    class (TAbstractApplicationService, IDocumentFlowAdministrationService)

      private

        type

          TPrivilegeServicesFactoryHolder = class

            PrivilegeServicesFactory: IDocumentFlowAdminPrivilegeServicesFactory;

            constructor Create(
              PrivilegeServicesFactory: IDocumentFlowAdminPrivilegeServicesFactory
            );
            
          end;
        
      private

        FCurrentDocumentFlowAdminPrivileges: TDocumentFlowAdminPrivileges;
        
        FDocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
        FNativeDocumentKindsReadService: INativeDocumentKindsReadService;
        FDocumentFlowAdminPrivilegeServicesFactories: IDocumentFlowAdminPrivilegeServicesFactories;
        
        FDocumentFlowAdminPrivilegeServicesFactoriesHash: TObjectHash;

        procedure AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
          Hash: TObjectHash;
          const PrivilegeId: Variant;
          DocumentFlowAdminPrivilegeServicesFactory: IDocumentFlowAdminPrivilegeServicesFactory
        );

        function CreateDocumentFlowAdminPrivilegeServices(
          const PrivilegeId: Variant
        ): TDocumentFlowAdminPrivilegeServices;

      private

        procedure EnsureClientHasAdminRoles(const ClientId: Variant);
        
      public

        destructor Destroy; override;
        
        constructor Create(
          DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
          NativeDocumentKindsReadService: INativeDocumentKindsReadService;
          DocumentFlowAdminPrivilegeServicesFactories: IDocumentFlowAdminPrivilegeServicesFactories
        );
        
      public

        function HasClientSystemAdministrationPrivileges(
          const ClientIdentity: Variant
        ): Boolean;

        function GetAllSystemAdministrationPrivileges(
          const ClientIdentity: Variant
        ): TSystemAdministrationPrivileges;

        function GetSystemAdministrationPrivilegeServices(
          const ClientIdentity: Variant;
          const PrivilegeIdentity: Variant
        ): TSystemAdministrationPrivilegeServices;

      public

        function HasClientDocumentFlowAdministrationPrivileges(
          const ClientIdentity: Variant
        ): Boolean;

        function GetAllDocumentFlowAdministrationPrivileges(
          const ClientIdentity: Variant
        ): TDocumentFlowAdminPrivileges;

        function GetDocumentFlowAdministrationPrivilegeServices(
          const ClientIdentity: Variant;
          const PrivilegeIdentity: Variant
        ): TDocumentFlowAdminPrivilegeServices;

    end;

implementation

uses

  Variants,
  Disposable,
  DocumentKinds;

{ TStandardDocumentFlowAdministrationService }

constructor TStandardDocumentFlowAdministrationService.Create(
  DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
  NativeDocumentKindsReadService: INativeDocumentKindsReadService;
  DocumentFlowAdminPrivilegeServicesFactories: IDocumentFlowAdminPrivilegeServicesFactories
);
begin

  inherited Create;

  FDocumentFlowAuthorizationService := DocumentFlowAuthorizationService;
  FNativeDocumentKindsReadService := NativeDocumentKindsReadService;
  FDocumentFlowAdminPrivilegeServicesFactories := DocumentFlowAdminPrivilegeServicesFactories;

  FDocumentFlowAdminPrivilegeServicesFactoriesHash := TObjectHash.Create;
  
end;

destructor TStandardDocumentFlowAdministrationService.Destroy;
begin

  FreeAndNil(FDocumentFlowAdminPrivilegeServicesFactoriesHash);
  FreeAndNil(FCurrentDocumentFlowAdminPrivileges);

  inherited;

end;

procedure TStandardDocumentFlowAdministrationService.EnsureClientHasAdminRoles(
  const ClientId: Variant
);
var
    ClientSystemRoleFlags: TDocumentFlowSystemRoleFlags;
    Disposable: IDisposable;
begin

  ClientSystemRoleFlags := TDocumentFlowSystemRoleFlags.Create;
  Disposable := ClientSystemRoleFlags;

  ClientSystemRoleFlags.HasAdminViewRole := True;

  FDocumentFlowAuthorizationService.EnsureEmployeeHasSystemRoles(
    ClientId, ClientSystemRoleFlags
  );

end;

function TStandardDocumentFlowAdministrationService.
  GetAllDocumentFlowAdministrationPrivileges(
    const ClientIdentity: Variant
  ): TDocumentFlowAdminPrivileges;
begin

  Result :=
    TDocumentFlowAdminPrivileges(
      GetAllSystemAdministrationPrivileges(ClientIdentity)
    );
  
end;

function TStandardDocumentFlowAdministrationService.
  GetAllSystemAdministrationPrivileges(
    const ClientIdentity: Variant
  ): TSystemAdministrationPrivileges;
var
    NativeDocumentKindDtos: TDocumentKindDtos;
    DocumentsPrivilegeId: Variant;
    CurrentGlobalId: Integer;
    PrivilegeIdString: String;
    TopLevelPrivilegeIdString: String;
    DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
    NewDocumentFlowAdminPrivileges: TDocumentFlowAdminPrivileges;

    PersonnelOrderPrivilege: TDocumentFlowAdminPrivilege;

    function AddNewPrivilege(
      DocumentFlowAdminPrivileges: TSystemAdministrationPrivileges;
      const Name: String;
      const TopLevelPrivilegeIdentity: Variant;
      const HasServices: Boolean = True
    ): TDocumentFlowAdminPrivilege;
    begin

      Inc(CurrentGlobalId);

      Result :=
        TDocumentFlowAdminPrivilege.Create(
          CurrentGlobalId,
          CurrentGlobalId,
          TopLevelPrivilegeIdentity,
          Name,
          HasServices
        );

      try

        DocumentFlowAdminPrivileges.Add(Result);

      except

        on E: Exception do begin

          FreeAndNil(Result);

          Raise;

        end;

      end;

    end;

    function AddDocumentKindPrivileges(
      DocumentFlowAdminPrivileges: TSystemAdministrationPrivileges;
      NativeDocumentKindDtos: TDocumentKindDtos
    ): Integer;
    var
        DocumentsPrivilege: TDocumentFlowAdminPrivilege;
        NativeDocumentKindDto: TDocumentKindDto;
        WorkingGlobalIdMappings: TIntegerHash;
        PersonnelOrderAdminPrivilege: TDocumentFlowAdminPrivilege;
    begin

      WorkingGlobalIdMappings	:= TIntegerHash.Create;

      try

        DocumentsPrivilege := TDocumentFlowAdminPrivilege.Create;

        DocumentFlowAdminPrivileges.Add(DocumentsPrivilege);
        
        Inc(CurrentGlobalId);
          
        DocumentsPrivilege.Identity := CurrentGlobalId;
        DocumentsPrivilege.Name := 'Документы';

        for NativeDocumentKindDto in NativeDocumentKindDtos do begin

          DocumentFlowAdminPrivilege := TDocumentFlowAdminPrivilege.Create;

          DocumentFlowAdminPrivileges.Add(DocumentFlowAdminPrivilege);

          with DocumentFlowAdminPrivilege do begin

            WorkingPrivilegeId := NativeDocumentKindDto.Id;
            Name := NativeDocumentKindDto.Name;

            PrivilegeIdString := VarToStr(NativeDocumentKindDto.Id);

            if not WorkingGlobalIdMappings.Exists(PrivilegeIdString) then begin

              Inc(CurrentGlobalId);

              Identity := CurrentGlobalId;

              WorkingGlobalIdMappings[PrivilegeIdString] := CurrentGlobalId;
              
            end

            else Identity := WorkingGlobalIdMappings[PrivilegeIdString];

            if not VarIsNull(NativeDocumentKindDto.TopLevelDocumentKindId)
            then begin
            
              TopLevelPrivilegeIdString := VarToStr(NativeDocumentKindDto.TopLevelDocumentKindId);

              if not WorkingGlobalIdMappings.Exists(TopLevelPrivilegeIdString)
              then begin

                Inc(CurrentGlobalId);

                TopLevelPrivilegeIdentity := CurrentGlobalId;

                WorkingGlobalIdMappings[TopLevelPrivilegeIdString] := TopLevelPrivilegeIdentity;

              end

              else TopLevelPrivilegeIdentity := WorkingGlobalIdMappings[TopLevelPrivilegeIdString];

            end

            else TopLevelPrivilegeIdentity := DocumentsPrivilege.Identity;

            { refactor: get info from DocumentKindDto }
            HasServices :=
              NativeDocumentKindDto.ServiceType.InheritsFrom(TOutcomingDocumentKind) or
              NativeDocumentKindDto.ServiceType.InheritsFrom(TIncomingDocumentKind) or
              NativeDocumentKindDto.ServiceType.InheritsFrom(TApproveableDocumentKind) or
              NativeDocumentKindDto.ServiceType.InheritsFrom(TIncomingInternalDocumentKind) or
              NativeDocumentKindDto.ServiceType.InheritsFrom(TOutcomingInternalDocumentKind) or
              NativeDocumentKindDto.ServiceType.InheritsFrom(TPersonnelOrderKind);
            
          end;

          AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
            FDocumentFlowAdminPrivilegeServicesFactoriesHash,
            DocumentFlowAdminPrivilege.Identity,
            FDocumentFlowAdminPrivilegeServicesFactories.CreateDocumentsAdminPrivilegeServicesFactory(
              DocumentFlowAdminPrivilege
            )
          );

          if not NativeDocumentKindDto.ServiceType.InheritsFrom(TPersonnelOrderKind) then Continue;

          PersonnelOrderAdminPrivilege :=
            AddNewPrivilege(
              DocumentFlowAdminPrivileges,
              'Сотрудники',
              DocumentFlowAdminPrivilege.Identity
            );

          AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
            FDocumentFlowAdminPrivilegeServicesFactoriesHash,
            PersonnelOrderAdminPrivilege.Identity,
            FDocumentFlowAdminPrivilegeServicesFactories.CreatePersonnelOrderEmployeesAdminPrivilegeServicesFactory(
              PersonnelOrderAdminPrivilege
            )
          );

          PersonnelOrderAdminPrivilege :=
            AddNewPrivilege(
              DocumentFlowAdminPrivileges,
              'Группы контроля',
              DocumentFlowAdminPrivilege.Identity
            );

          AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
            FDocumentFlowAdminPrivilegeServicesFactoriesHash,
            PersonnelOrderAdminPrivilege.Identity,
            FDocumentFlowAdminPrivilegeServicesFactories.CreatePersonnelOrderControlGroupsAdminPrivilegeServicesFactory(
              PersonnelOrderAdminPrivilege
            )
          );

          PersonnelOrderAdminPrivilege :=
            AddNewPrivilege(
              DocumentFlowAdminPrivileges,
              'Согласованты подтипов',
              DocumentFlowAdminPrivilege.Identity
            );

          AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
            FDocumentFlowAdminPrivilegeServicesFactoriesHash,
            PersonnelOrderAdminPrivilege.Identity,
            FDocumentFlowAdminPrivilegeServicesFactories.CreatePersonnelOrderKindApproversAdminPrivilegeServicesFactory(
              PersonnelOrderAdminPrivilege
            )
          );

          PersonnelOrderAdminPrivilege :=
            AddNewPrivilege(
              DocumentFlowAdminPrivileges,
              'Подписанты',
              DocumentFlowAdminPrivilege.Identity
            );

          AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
            FDocumentFlowAdminPrivilegeServicesFactoriesHash,
            PersonnelOrderAdminPrivilege.Identity,
            FDocumentFlowAdminPrivilegeServicesFactories.CreatePersonnelOrderSignersAdminPrivilegeServicesFactory(
              PersonnelOrderAdminPrivilege
            )
          );

        end;

        Result := DocumentsPrivilege.Identity;

      finally

        FreeAndNil(WorkingGlobalIdMappings);
        
      end;

    end;
    
begin

  EnsureClientHasAdminRoles(ClientIdentity);

  NativeDocumentKindDtos :=
    FNativeDocumentKindsReadService.GetNativeDocumentKindDtos;

  try

    NewDocumentFlowAdminPrivileges := TDocumentFlowAdminPrivileges.Create;


    try

      FDocumentFlowAdminPrivilegeServicesFactoriesHash.Clear;

      CurrentGlobalId := 0;

      if
        Assigned(NativeDocumentKindDtos)
        and not NativeDocumentKindDtos.IsEmpty
      then begin

        DocumentsPrivilegeId :=
          AddDocumentKindPrivileges(
            NewDocumentFlowAdminPrivileges, NativeDocumentKindDtos
          );

        DocumentFlowAdminPrivilege :=
          AddNewPrivilege(
            NewDocumentFlowAdminPrivileges, 'Нумераторы', DocumentsPrivilegeId
          );

        AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
          FDocumentFlowAdminPrivilegeServicesFactoriesHash,
          DocumentFlowAdminPrivilege.Identity,
          FDocumentFlowAdminPrivilegeServicesFactories.CreateDocumentNumeratorsAdminPrivilegeServicesFactory(
            DocumentFlowAdminPrivilege
          )
        );

      end;

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Сотрудники', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,
        FDocumentFlowAdminPrivilegeServicesFactories.CreateEmployeesAdminPrivilegeServicesFactory(
          DocumentFlowAdminPrivilege
        )
      );

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Замещения', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,
        FDocumentFlowAdminPrivilegeServicesFactories.CreateEmployeesReplacementsAdminPrivilegeServicesFactory(
          DocumentFlowAdminPrivilege
        )
      );

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Рабочие группы', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,
        FDocumentFlowAdminPrivilegeServicesFactories.CreateEmployeesWorkGroupsAdminPrivilegeServicesFactory(
          DocumentFlowAdminPrivilege
        )
      );

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Структура предприятия', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,
        FDocumentFlowAdminPrivilegeServicesFactories.CreateDepartmentsAdminPrivilegeServicesFactory(
          DocumentFlowAdminPrivilege
        )
      );

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Состав подразделений', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,
        FDocumentFlowAdminPrivilegeServicesFactories.CreateEmpoyeeStaffsAdminPrivilegeServicesFactory(
          DocumentFlowAdminPrivilege
        )
      );

      DocumentFlowAdminPrivilege :=
        AddNewPrivilege(NewDocumentFlowAdminPrivileges, 'Синхронизация данных', Null);

      AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
        FDocumentFlowAdminPrivilegeServicesFactoriesHash,
        DocumentFlowAdminPrivilege.Identity,

        FDocumentFlowAdminPrivilegeServicesFactories
          .CreateSynchronizationDataAdminPrivilegeServicesFactory(
            DocumentFlowAdminPrivilege
          )
      );

      FreeAndNil(FCurrentDocumentFlowAdminPrivileges);

      FCurrentDocumentFlowAdminPrivileges := NewDocumentFlowAdminPrivileges;

      Result := FCurrentDocumentFlowAdminPrivileges;
      
    except

      on E: Exception do begin

        FreeAndNil(NewDocumentFlowAdminPrivileges);

        Raise;

      end;

    end;

  finally

    FreeAndNil(NativeDocumentKindDtos);

  end;
  
end;

function TStandardDocumentFlowAdministrationService.
  GetDocumentFlowAdministrationPrivilegeServices(
    const ClientIdentity, PrivilegeIdentity: Variant
  ): TDocumentFlowAdminPrivilegeServices;
begin

  Result :=
    TDocumentFlowAdminPrivilegeServices(
      GetSystemAdministrationPrivilegeServices(
        ClientIdentity, PrivilegeIdentity
      )
    );
    
end;

function TStandardDocumentFlowAdministrationService.
  GetSystemAdministrationPrivilegeServices(
    const ClientIdentity, PrivilegeIdentity: Variant
  ): TSystemAdministrationPrivilegeServices;
begin

  if FDocumentFlowAdminPrivilegeServicesFactoriesHash.ItemCount = 0 then
    GetAllSystemAdministrationPrivileges(ClientIdentity)

  else EnsureClientHasAdminRoles(ClientIdentity);

  Result :=
    CreateDocumentFlowAdminPrivilegeServices(PrivilegeIdentity);
  
end;

function TStandardDocumentFlowAdministrationService.
  HasClientDocumentFlowAdministrationPrivileges(
    const ClientIdentity: Variant
  ): Boolean;
begin

  Result :=
    HasClientSystemAdministrationPrivileges(ClientIdentity);
    
end;

function TStandardDocumentFlowAdministrationService.
  HasClientSystemAdministrationPrivileges(
    const ClientIdentity: Variant
  ): Boolean;
begin

  try

    GetAllSystemAdministrationPrivileges(ClientIdentity);

    Result := True;
    
  except

    on E: TDocumentFlowAuthorizationServiceException do Result := False;

  end;

end;

procedure TStandardDocumentFlowAdministrationService.AddDocumentFlowAdminPrivilegeServicesFactoryToHash(
  Hash: TObjectHash;
  const PrivilegeId: Variant;
  DocumentFlowAdminPrivilegeServicesFactory: IDocumentFlowAdminPrivilegeServicesFactory
);
begin

  Hash[VarToStr(PrivilegeId)] :=
    TPrivilegeServicesFactoryHolder.Create(
      DocumentFlowAdminPrivilegeServicesFactory
    );

end;

function TStandardDocumentFlowAdministrationService.CreateDocumentFlowAdminPrivilegeServices(
  const PrivilegeId: Variant
): TDocumentFlowAdminPrivilegeServices;
begin

  if not FDocumentFlowAdminPrivilegeServicesFactoriesHash.Exists(PrivilegeId)
  then begin

    raise TDocumentFlowAuthorizationServiceException.Create(
      'Для затребованной привелегии администрирования ' +
      'службы отсутствуют'
    );

  end;

  Result :=
    TPrivilegeServicesFactoryHolder(
      FDocumentFlowAdminPrivilegeServicesFactoriesHash[PrivilegeId]
    )
    .PrivilegeServicesFactory
      .CreateDocumentFlowAdminPrivilegeServices;

end;

{ TStandardDocumentFlowAdministrationService.TPrivilegeServicesFactoryHolder }

constructor TStandardDocumentFlowAdministrationService.TPrivilegeServicesFactoryHolder.Create(
  PrivilegeServicesFactory: IDocumentFlowAdminPrivilegeServicesFactory
);
begin

  inherited Create;

  Self.PrivilegeServicesFactory := PrivilegeServicesFactory;

end;

end.
