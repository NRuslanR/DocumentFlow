unit AbstractEmployeeDocumentWorkStatisticsZeosService;

interface

uses

  EmployeeDocumentWorkStatistics,
  EmployeeDocumentWorkStatisticsService,
  IEmployeeRepositoryUnit,
  DocumentKinds,
  DocumentKindResolver,
  ZDataset,
  ZConnection,
  SysUtils,
  Classes;

type

  TAbstractEmployeeDocumentWorkStatisticsZeosService =
    class (TInterfacedObject, IEmployeeDocumentWorkStatisticsService)

      protected

        FZQuery: TZQuery;
        FConnection: TZConnection;
        FEmployeeRepository: IEmployeeRepository;
        FDocumentKindResolver: IDocumentKindResolver;

        function GetConnection: TZConnection;
        procedure SetConnection(const Value: TZConnection);

        procedure Initialize(
          EmployeeRepository: IEmployeeRepository;
          Connection: TZConnection;
          DocumentKindResolver: IDocumentKindResolver
        );

        function InternalGetDocumentWorkStatisticsForEmployee(
          const EmployeeId: Variant
        ): TEmployeeDocumentWorkStatisticsList; virtual;

        procedure InternalGetDocumentWorkStatisticsForEmployeeAsync(
          const EmployeeId: Variant;

          OnDocumentWorkStatisticsFetchedEventHandler:
            TOnDocumentWorkStatisticsFetchedEventHandler;

          OnDocumentWorkStatisticsFetchingErrorEventHandler:
            TOnDocumentWorkStatisticsFetchingErrorEventHandler
            
        ); virtual;
        
        function InternalGetDocumentKindsWorkStatisticsForEmployee(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;

          const EmployeeId: Variant
        ): TEmployeeDocumentWorkStatisticsList; virtual; abstract;

        procedure InternalGetDocumentKindsWorkStatisticsForEmployeeAsync(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;
          
          const EmployeeId: Variant;

          OnDocumentWorkStatisticsFetchedEventHandler:
            TOnDocumentWorkStatisticsFetchedEventHandler;

          OnDocumentWorkStatisticsFetchingErrorEventHandler:
            TOnDocumentWorkStatisticsFetchingErrorEventHandler

        ); virtual; abstract;
        
      public

        destructor Destroy; override;

        constructor Create(
          Connection: TZConnection;
          EmployeeRepository: IEmployeeRepository;
          DocumentKindResolver: IDocumentKindResolver
        ); overload;

        function GetDocumentWorkStatisticsForEmployee(
          const EmployeeId: Variant
        ): TEmployeeDocumentWorkStatisticsList;

        procedure GetDocumentWorkStatisticsForEmployeeAsync(
          const EmployeeId: Variant;

          OnDocumentWorkStatisticsFetchedEventHandler:
            TOnDocumentWorkStatisticsFetchedEventHandler;

          OnDocumentWorkStatisticsFetchingErrorEventHandler:
            TOnDocumentWorkStatisticsFetchingErrorEventHandler
        );
        
        function GetDocumentKindsWorkStatisticsForEmployee(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;

          const EmployeeId: Variant

        ): TEmployeeDocumentWorkStatisticsList;

        procedure GetDocumentKindsWorkStatisticsForEmployeeAsync(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;
          
          const EmployeeId: Variant;

          OnDocumentWorkStatisticsFetchedEventHandler:
            TOnDocumentWorkStatisticsFetchedEventHandler;

          OnDocumentWorkStatisticsFetchingErrorEventHandler:
            TOnDocumentWorkStatisticsFetchingErrorEventHandler
        );

        function GetSelf: TObject;
        
      published

        property Connection: TZConnection
        read GetConnection write SetConnection;
        
    end;

implementation

{ TAbstractEmployeeDocumentWorkStatisticsZeosService }

constructor TAbstractEmployeeDocumentWorkStatisticsZeosService.Create(
  Connection: TZConnection;
  EmployeeRepository: IEmployeeRepository;
  DocumentKindResolver: IDocumentKindResolver
);
begin

  inherited Create;

  Initialize(EmployeeRepository, Connection, DocumentKindResolver);
  
end;

destructor TAbstractEmployeeDocumentWorkStatisticsZeosService.Destroy;
begin

  FreeAndNil(FZQuery);
  inherited;

end;

function TAbstractEmployeeDocumentWorkStatisticsZeosService.GetConnection: TZConnection;
begin

  Result := FZQuery.Connection;
  
end;

function TAbstractEmployeeDocumentWorkStatisticsZeosService.
  GetDocumentKindsWorkStatisticsForEmployee(
    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;
    const EmployeeId: Variant
  ): TEmployeeDocumentWorkStatisticsList;
begin

  Result :=
    InternalGetDocumentKindsWorkStatisticsForEmployee(
      OutcommingDocumentKinds,
      ApproveableDocumentKinds,
      IncommingDocumentKinds,
      EmployeeId
    );

end;

procedure TAbstractEmployeeDocumentWorkStatisticsZeosService.
  GetDocumentKindsWorkStatisticsForEmployeeAsync(

    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;

    const EmployeeId: Variant;

    OnDocumentWorkStatisticsFetchedEventHandler:
      TOnDocumentWorkStatisticsFetchedEventHandler;

    OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
  );
begin

  InternalGetDocumentKindsWorkStatisticsForEmployeeAsync(
    OutcommingDocumentKinds,
    ApproveableDocumentKinds,
    IncommingDocumentKinds,
    EmployeeId,
    OnDocumentWorkStatisticsFetchedEventHandler,
    OnDocumentWorkStatisticsFetchingErrorEventHandler
  );
  
end;

function TAbstractEmployeeDocumentWorkStatisticsZeosService.
  GetDocumentWorkStatisticsForEmployee(
    const EmployeeId: Variant
  ): TEmployeeDocumentWorkStatisticsList;
begin

  Result := InternalGetDocumentWorkStatisticsForEmployee(EmployeeId);
  
end;

procedure TAbstractEmployeeDocumentWorkStatisticsZeosService.
  GetDocumentWorkStatisticsForEmployeeAsync(
    const EmployeeId: Variant;

    OnDocumentWorkStatisticsFetchedEventHandler:
      TOnDocumentWorkStatisticsFetchedEventHandler;

    OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler

  );
begin

  InternalGetDocumentWorkStatisticsForEmployeeAsync(
    EmployeeId,
    OnDocumentWorkStatisticsFetchedEventHandler,
    OnDocumentWorkStatisticsFetchingErrorEventHandler
  );

end;

function TAbstractEmployeeDocumentWorkStatisticsZeosService.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TAbstractEmployeeDocumentWorkStatisticsZeosService.Initialize(
  EmployeeRepository: IEmployeeRepository;
  Connection: TZConnection;
  DocumentKindResolver: IDocumentKindResolver
);
begin

  FZQuery := TZQuery.Create(nil);

  Self.Connection := Connection;

  FEmployeeRepository := EmployeeRepository;

  FDocumentKindResolver := DocumentKindResolver;
  
end;

function TAbstractEmployeeDocumentWorkStatisticsZeosService.
  InternalGetDocumentWorkStatisticsForEmployee(

    const EmployeeId: Variant

  ): TEmployeeDocumentWorkStatisticsList;
begin

  Result :=
    GetDocumentKindsWorkStatisticsForEmployee(
      [TOutcomingServiceNoteKind],
      [TApproveableServiceNoteKind],
      [TIncomingServiceNoteKind],
      EmployeeId
    );
    
end;

procedure TAbstractEmployeeDocumentWorkStatisticsZeosService.
  InternalGetDocumentWorkStatisticsForEmployeeAsync(
    const EmployeeId: Variant;

    OnDocumentWorkStatisticsFetchedEventHandler:
      TOnDocumentWorkStatisticsFetchedEventHandler;

    OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
  );
begin

  GetDocumentKindsWorkStatisticsForEmployeeAsync(
    [TOutcomingServiceNoteKind],
    [TApproveableServiceNoteKind],
    [TIncomingServiceNoteKind],
    EmployeeId,
    OnDocumentWorkStatisticsFetchedEventHandler,
    OnDocumentWorkStatisticsFetchingErrorEventHandler
  );
  
end;

procedure TAbstractEmployeeDocumentWorkStatisticsZeosService.SetConnection(
  const Value: TZConnection);
begin

  FConnection := Value;
  FZQuery.Connection := Value;
  
end;

end.
