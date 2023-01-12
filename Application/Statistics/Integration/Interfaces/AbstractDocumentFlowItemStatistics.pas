unit AbstractDocumentFlowItemStatistics;

interface

uses

  SysUtils,
  Classes;

type

  IDocumentFlowItemStatistics = interface
    ['{54D97CAF-B56F-446B-9372-1B9AB2FA79A2}']

    function GetItemId: Variant;
    procedure SetItemId(const Value: Variant);

    function ToString: String;

    property ItemId: Variant read GetItemId write SetItemId;

  end;

  TAbstractDocumentFlowItemStatistics =
    class abstract (TInterfacedObject, IDocumentFlowItemStatistics)

      private

        FItemId: Variant;
      
      public

        constructor Create; overload;
        constructor Create(const ItemId: Variant); overload;

        function GetItemId: Variant;
        procedure SetItemId(const Value: Variant);

        function ToString: String; virtual; abstract;

        property ItemId: Variant read GetItemId write SetItemId;

    end;

implementation

{ TDocumentFlowItemStatistics }

constructor TAbstractDocumentFlowItemStatistics.Create;
begin

  inherited;

end;

constructor TAbstractDocumentFlowItemStatistics.Create(const ItemId: Variant);
begin

  inherited Create;

end;

function TAbstractDocumentFlowItemStatistics.GetItemId: Variant;
begin

  Result := FItemId;

end;

procedure TAbstractDocumentFlowItemStatistics.SetItemId(const Value: Variant);
begin

  FItemId := Value;

end;

end.
