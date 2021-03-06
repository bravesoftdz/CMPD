unit uConsPessoa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  SMDBGrid, ExtCtrls, RxLookup, StdCtrls, DBCtrls, rsDBUtils, NxPageControl, uDMCadPessoa,
  uDMConsPessoa, Buttons, RXCtrls;

type
  TfrmConsPessoa = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Panel3: TPanel;
    nxPCGeral: TNxPageControl;
    ts_Cidade: TNxTabSheet;
    SMDBGrid1: TSMDBGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    dbcbxUf: TComboBox;
    Label2: TLabel;
    dbrxCidade: TRxDBLookupCombo;
    ts_TipoDeficiencia: TNxTabSheet;
    SMDBGrid2: TSMDBGrid;
    rdgOrdem: TRadioGroup;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    lblTotalGeral: TLabel;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    RxLabel3: TRxLabel;
    RxLabel4: TRxLabel;
    RxLabel5: TRxLabel;
    lblAuditiva: TRxLabel;
    lblVisual: TRxLabel;
    lblMental: TRxLabel;
    lblFisica: TRxLabel;
    lblMultipla: TRxLabel;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    dbrxTipoDeficiencia: TRxDBLookupCombo;
    Panel4: TPanel;
    btnPesquisar: TBitBtn;
    btnImprimir: TBitBtn;
    GroupBox5: TGroupBox;
    ts_Escolaridade: TNxTabSheet;
    SMDBGrid3: TSMDBGrid;
    Label5: TLabel;
    cbEscolaridade: TComboBox;
    GroupBox6: TGroupBox;
    Label6: TLabel;
    dbrxEmpresa: TRxDBLookupCombo;
    ts_PasseLivre: TNxTabSheet;
    SMDBGrid4: TSMDBGrid;
    ts_Estacionamento: TNxTabSheet;
    SMDBGrid5: TSMDBGrid;
    procedure FormShow(Sender: TObject);
    procedure dbcbxUfChange(Sender: TObject);
    procedure dbcbxUfExit(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure cbEscolaridadeExit(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure dbrxEmpresaExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    ctCidade, ctTipoDeficiencia, ctEscolaridade, ctPasseLivre, ctEstacionamento: string;
    vTotal: Integer;
    procedure prc_Abrir_Cidade(UF: string);
    procedure prc_Montar_Consulta;
    procedure prc_Montar_Total;
    procedure prc_Abrir_qEmpresa(ID: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConsPessoa: TfrmConsPessoa;
  fDMCadPessoa: TDMPessoa;
  fDMConsPessoa: TDMConsPessoa;

implementation

uses
  SqlExpr, DB;


{$R *.dfm}

procedure TfrmConsPessoa.prc_Abrir_Cidade(UF: string);
begin
  fDMCadPessoa.cdsCidadeConsulta.Close;
  fDMCadPessoa.sdsCidadeConsulta.ParamByName('UF').asString := UF;
  fDMCadPessoa.cdsCidadeConsulta.Open;
end;

procedure TfrmConsPessoa.FormShow(Sender: TObject);
begin
  fDMCadPessoa := TDMPessoa.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMCadPessoa);
  fDMConsPessoa := TDMConsPessoa.Create(Self);
  oDBUtils.SetDataSourceProperties(Self, fDMConsPessoa);
  ctCidade := fDMConsPessoa.sdsConsCidade.CommandText;
  ctTipoDeficiencia := fDMConsPessoa.sdsConsTD.CommandText;
  ctEscolaridade := fDMConsPessoa.sdsConsEscolaridade.CommandText;
  ctPasseLivre := fDMConsPessoa.sdsConsPasseLivre.CommandText;
  ctEstacionamento := fDMConsPessoa.sdsConsEstacionamento.CommandText;
  fDMConsPessoa.cdsTipoDeficiencia.Close;
  fDMConsPessoa.cdsTipoDeficiencia.Open;
  fDMConsPessoa.cdsConsEmpresa.Close;
  fDMConsPessoa.cdsConsEmpresa.Open;
  nxPCGeral.ActivePage := ts_Cidade;
  dbrxEmpresa.KeyValue := 1;
end;

procedure TfrmConsPessoa.dbcbxUfChange(Sender: TObject);
begin
  prc_Abrir_Cidade(dbcbxUf.items[dbcbxUf.ItemIndex]);
end;

procedure TfrmConsPessoa.dbcbxUfExit(Sender: TObject);
begin
  prc_Abrir_Cidade(dbcbxUf.items[dbcbxUf.ItemIndex]);
end;

procedure TfrmConsPessoa.btnPesquisarClick(Sender: TObject);
begin
  prc_Montar_Consulta;
  prc_Montar_Total;
end;

procedure TfrmConsPessoa.prc_Montar_Consulta;
var
  vCidade, vTipoDeficiencia, vEscolaridade, vPasseLivre, vOrdem: string;
  vID: Integer;
begin
  vOrdem := ' ORDER BY ';
  if rdgOrdem.ItemIndex = 0 then
    vOrdem := vOrdem + ' P.CODIGO'
  else
    vOrdem := vOrdem + ' P.NOME';
  if nxPCGeral.ActivePage = ts_Cidade then
  begin
    vCidade := ' WHERE 0 = 0 ';
    fDMConsPessoa.cdsConsCidade.Close;
    if dbrxCidade.KeyValue > 0 then
    begin
      vCidade := vCidade + ' AND P.ID_CIDADE = ' + fDMCadPessoa.cdsCidadeConsultaID.AsString;
    end;
    vCidade := vCidade + vOrdem;
    fDMConsPessoa.sdsConsCidade.CommandText := ctCidade + vCidade;
    fDMConsPessoa.cdsConsCidade.Open;
  end;

  if nxPCGeral.ActivePage = ts_TipoDeficiencia then
  begin
    vTipoDeficiencia := ' WHERE 0 = 0';
    fDMConsPessoa.cdsConsTD.Close;
    if dbrxTipoDeficiencia.KeyValue > 0 then
    begin
      vTipoDeficiencia := vTipoDeficiencia + ' AND P.ID_DEFICIENCIA = ' + fDMConsPessoa.cdsTipoDeficienciaID.AsString;
    end;
    vTipoDeficiencia := vTipoDeficiencia + vOrdem;
    fDMConsPessoa.sdsConsTD.CommandText := ctTipoDeficiencia + vTipoDeficiencia;
    fDMConsPessoa.cdsConsTD.Open;
  end;

  if nxPCGeral.ActivePage = ts_Escolaridade then
  begin
    vEscolaridade := ' WHERE 0 = 0';
    fDMConsPessoa.cdsConsEscolaridade.Close;
    if cbEscolaridade.ItemIndex > -1 then
    begin
      vID := cbEscolaridade.ItemIndex + 1;
      vEscolaridade := vEscolaridade + ' AND ESCOLARIDADE = ' + IntToStr(vID);
    end;
    if dbrxTipoDeficiencia.KeyValue > 0 then
    begin
      vEscolaridade := vEscolaridade + ' AND P.ID_DEFICIENCIA = ' + fDMConsPessoa.cdsTipoDeficienciaID.AsString;
    end;

    vEscolaridade := vEscolaridade + vOrdem;
    fDMConsPessoa.sdsConsEscolaridade.CommandText := ctEscolaridade + vEscolaridade;
    fDMConsPessoa.cdsConsEscolaridade.Open;
  end;

  if nxPCGeral.ActivePage = ts_PasseLivre then
  begin
    fDMConsPessoa.cdsConsPasseLivre.Close;
    fDMConsPessoa.sdsConsPasseLivre.CommandText := ctPasseLivre + vOrdem;
    fDMConsPessoa.cdsConsPasseLivre.Open;
  end;

  if nxPCGeral.ActivePage = ts_Estacionamento then
  begin
    fDMConsPessoa.cdsConsEstacionamento.Close;
    fDMConsPessoa.sdsConsEstacionamento.CommandText := ctEstacionamento + vOrdem;
    fDMConsPessoa.cdsConsEstacionamento.Open;
  end;

end;

procedure TfrmConsPessoa.cbEscolaridadeExit(Sender: TObject);
begin
  prc_Abrir_Cidade(dbcbxUf.items[dbcbxUf.ItemIndex]);
end;

procedure TfrmConsPessoa.prc_Montar_Total;
begin
  fDMConsPessoa.qResumo.Close;
  fDMConsPessoa.qResumo.Open;
  vTotal := 0;
  if not (fDMConsPessoa.qResumo.IsEmpty) then
  begin
    while not fDMConsPessoa.qResumo.Eof do
    begin
      case fDMConsPessoa.qResumoID.AsInteger of
        1:
          lblAuditiva.Caption := IntToStr(fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger);
        2:
          lblVisual.Caption := IntToStr(fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger);
        3:
          lblMental.Caption := IntToStr(fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger);
        4:
          lblFisica.Caption := IntToStr(fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger);
        5:
          lblMultipla.Caption := IntToStr(fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger);
      end;
      vTotal := vTotal + fDMConsPessoa.qResumoTOTAL_DEFICIENCIA.AsInteger;
      fDMConsPessoa.qResumo.Next;
    end;
  end;
  lblVisual.Update;
  lblAuditiva.Update;
  lblMental.Update;
  lblMultipla.Update;
  lblFisica.Update;
  lblTotalGeral.Caption := IntToStr(vTotal);
  lblTotalGeral.Update;
end;

procedure TfrmConsPessoa.btnImprimirClick(Sender: TObject);
var
  vArq: string;
  vIndex: string;
begin
  if nxPCGeral.ActivePage = ts_Cidade then
  begin
    if fDMConsPessoa.cdsConsCidade.IsEmpty then
    begin
      MessageDlg('Nenhuma informa��o encontrada para gerar o relat�rio', mtInformation, [mbOK], 0);
      Exit;
    end;
    vIndex := fDMConsPessoa.cdsConsCidade.IndexFieldNames;
    fDMConsPessoa.cdsConsCidade.IndexFieldNames := 'Cidade';
    fDMConsPessoa.cdsConsCidade.First;

    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\PessoaPorCidade.fr3';
    if FileExists(vArq) then
      fDMConsPessoa.frxReport1.Report.LoadFromFile(vArq)
    else
    begin
      ShowMessage('Relat�rio n�o localizado! ' + vArq);
      Exit;
    end;
    fDMConsPessoa.frxReport1.ShowReport;
    fDMConsPessoa.cdsConsCidade.IndexFieldNames := vIndex;
  end;

  if nxPCGeral.ActivePage = ts_TipoDeficiencia then
  begin
    if fDMConsPessoa.cdsConsTD.IsEmpty then
    begin
      MessageDlg('Nenhuma informa��o encontrada para gerar o relat�rio', mtInformation, [mbOK], 0);
      Exit;
    end;
    fDMConsPessoa.cdsConsTD.First;
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\PessoaPorDeficiencia.fr3';
    if FileExists(vArq) then
      fDMConsPessoa.frxReport1.Report.LoadFromFile(vArq)
    else
    begin
      ShowMessage('Relat�rio n�o localizado! ' + vArq);
      Exit;
    end;
    fDMConsPessoa.frxReport1.ShowReport;
  end;

  if nxPCGeral.ActivePage = ts_Escolaridade then
  begin
    if fDMConsPessoa.cdsConsEscolaridade.IsEmpty then
    begin
      MessageDlg('Nenhuma informa��o encontrada para gerar o relat�rio', mtInformation, [mbOK], 0);
      Exit;
    end;
    fDMConsPessoa.cdsConsEscolaridade.First;
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\PessoaPorEscolaridade.fr3';
    if FileExists(vArq) then
      fDMConsPessoa.frxReport1.Report.LoadFromFile(vArq)
    else
    begin
      ShowMessage('Relat�rio n�o localizado! ' + vArq);
      Exit;
    end;
    fDMConsPessoa.frxReport1.ShowReport;
  end;
  if nxPCGeral.ActivePage = ts_PasseLivre then
  begin
    if fDMConsPessoa.cdsConsPasseLivre.IsEmpty then
    begin
      MessageDlg('Nenhuma informa��o encontrada para gerar o relat�rio', mtInformation, [mbOK], 0);
      Exit;
    end;
    fDMConsPessoa.cdsConsPasseLivre.First;
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\PessoaPasseLivre.fr3';
    if FileExists(vArq) then
      fDMConsPessoa.frxReport1.Report.LoadFromFile(vArq)
    else
    begin
      ShowMessage('Relat�rio n�o localizado! ' + vArq);
      Exit;
    end;
    fDMConsPessoa.frxReport1.ShowReport;
  end;

  if nxPCGeral.ActivePage = ts_Estacionamento then
  begin
    if fDMConsPessoa.cdsConsEstacionamento.IsEmpty then
    begin
      MessageDlg('Nenhuma informa��o encontrada para gerar o relat�rio', mtInformation, [mbOK], 0);
      Exit;
    end;
    fDMConsPessoa.cdsConsEstacionamento.First;
    vArq := ExtractFilePath(Application.ExeName) + 'Relatorios\PessoaEstacionamento.fr3';
    if FileExists(vArq) then
      fDMConsPessoa.frxReport1.Report.LoadFromFile(vArq)
    else
    begin
      ShowMessage('Relat�rio n�o localizado! ' + vArq);
      Exit;
    end;
    fDMConsPessoa.frxReport1.ShowReport;
  end;


end;

procedure TfrmConsPessoa.prc_Abrir_qEmpresa(ID: Integer);
begin
  fDMConsPessoa.qEmpresa.Close;
  fDMConsPessoa.qEmpresa.ParamByName('ID').AsInteger := ID;
  fDMConsPessoa.qEmpresa.Open;
end;

procedure TfrmConsPessoa.dbrxEmpresaExit(Sender: TObject);
begin
  if dbrxEmpresa.KeyValue > 0 then
    prc_Abrir_qEmpresa(dbrxEmpresa.KeyValue)
  else
    prc_Abrir_qEmpresa(-1);
end;

procedure TfrmConsPessoa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

end.

