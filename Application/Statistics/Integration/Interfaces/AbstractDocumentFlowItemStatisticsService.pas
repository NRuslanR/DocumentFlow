unit AbstractDocumentFlowItemStatisticsService;

interface

uses

  AbstractDocumentFlowItemStatistics,
  ApplicationService,
  AbstractApplicationService,
  SysUtils,
  Classes;

type

  IDocumentFlowItemStatisticsService = interface (IApplicationService)
    ['{05CFA1F2-41FC-4315-A2F6-E7D73A7A3D09}']

    function GetDocumentFlowItemStatistics(
      const ItemId: Variant;
      const ClientId: Variant
    ): IDocumentFlowItemStatistics;
    
  end;

  TAbstractDocumentFlowItemStatisticsService =
    class abstract (TAbstractApplicationService, IDocumentFlowItemStatisticsService)

      public

        function GetDocumentFlowItemStatistics(
          const ItemId: Variant;
          const ClientId: Variant
        ): IDocumentFlowItemStatistics; virtual; abstract;

    end;

implementation

end.
