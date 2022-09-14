unit StandardDocumentKindWorkCycleInfoService;

interface

uses

  DocumentKindWorkCycleInfoService,
  DocumentKindWorkCycleInfo,
  DocumentWorkCycle,
  DocumentKindFinder,
  DocumentKind,
  DocumentWorkCycleFinder,
  Document,
  SysUtils,
  Classes;

type

  TStandardDocumentKindWorkCycleInfoService =
    class (TInterfacedObject, IDocumentKindWorkCycleInfoService)

      private

        FDocumentKindFinder: IDocumentKindFinder;
        FDocumentWorkCycleFinder: IDocumentWorkCycleFinder;

      public

        constructor Create(
          DocumentKindFinder: IDocumentKindFinder;
          DocumentWorkCycleFinder: IDocumentWorkCycleFinder
        );
        
        function GetDocumentKindWorkCycleInfo(
          const DocumentKind: TDocumentClass
        ): TDocumentKindWorkCycleInfo;

        function GetDocumentKindWorkCycleInfos(
          const DocumentKinds:  array of TDocumentClass
        ): TDocumentKindWorkCycleInfos;

        function GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos;
      
    end;

implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

{ TStandardDocumentKindWorkCycleInfoService }

constructor TStandardDocumentKindWorkCycleInfoService.Create(
  DocumentKindFinder: IDocumentKindFinder;
  DocumentWorkCycleFinder: IDocumentWorkCycleFinder
);
begin

  inherited Create;

  FDocumentKindFinder := DocumentKindFinder;
  FDocumentWorkCycleFinder := DocumentWorkCycleFinder;
  
end;

function TStandardDocumentKindWorkCycleInfoService.
  GetAllDocumentKindWorkCycleInfos: TDocumentKindWorkCycleInfos;
var
    DocumentKinds: TDocumentKinds;
    Free: IDomainObjectBaseList;
begin

  DocumentKinds := FDocumentKindFinder.LoadAllDocumentKinds;

  if not Assigned(DocumentKinds) then Exit;
  
  Free := DocumentKinds;

  Result := GetDocumentKindWorkCycleInfos(DocumentKinds.FetchDocumentClasses);
    
end;

function TStandardDocumentKindWorkCycleInfoService.
  GetDocumentKindWorkCycleInfos(
    const DocumentKinds: array of TDocumentClass
  ): TDocumentKindWorkCycleInfos;
var DocumentKind: TDocumentClass;
begin

  Result := TDocumentKindWorkCycleInfos.Create;

  try

    for DocumentKind in DocumentKinds do
      Result.Add(GetDocumentKindWorkCycleInfo(DocumentKind));

  except

    on E: Exception do begin

      FreeAndNil(Result);

      raise;
      
    end;

  end;

end;

function TStandardDocumentKindWorkCycleInfoService.
  GetDocumentKindWorkCycleInfo(
    const DocumentKind: TDocumentClass
  ): TDocumentKindWorkCycleInfo;
var
    DocumentKindInstance: TDocumentKind;
    Free: IDomainObjectBase;
begin

  DocumentKindInstance :=
    FDocumentKindFinder.FindDocumentKindByClassType(DocumentKind);

  Free := DocumentKindInstance;
  
  Result :=
    TDocumentKindWorkCycleInfo.Create(
      DocumentKind,
      FDocumentWorkCycleFinder.FindWorkCycleForDocumentKind(
        DocumentKindInstance.Identity
      )
    );

end;

end.
