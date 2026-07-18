function AmpacityGUI
clc;
ui = uifigure('Name','Ampacity Suitability Meter','Position',[400 50 650 700]);
ui.Color = [0.95 0.96 1];
outer = uipanel(ui,'Position',[0 0 650 700]);
outer.Scrollable = 'on';
inner = uipanel(outer,'Position',[0 0 630 1200]);
main = uigridlayout(inner, [16 2]);
main.RowHeight = repmat({55}, 1, 16);
main.ColumnWidth = {'1x','1x'};
main.Padding = [15 15 15 15];
main.RowSpacing = 12;
main.ColumnSpacing = 12;
lblTitle = uilabel(main,"Text","Ampacity Suitability Calculator",...
   "FontSize",18,"FontWeight","bold","HorizontalAlignment","center");
lblTitle.Layout.Column = [1 2];
D        = addField(main,"Conductor Diameter D (m)",0.01);
rho25    = addField(main,"Resistivity @25°C (ohm·m)",1.68e-8);
alpha    = addField(main,"Temp Coefficient (1/°C)",0.00393);
T_op     = addSlider(main,"Operating Temp (°C)",10,200,75);
T_amb    = addSlider(main,"Ambient Temp (°C)",0,50,32);
T_allow  = addSlider(main,"Max Allowable Temp (°C)",30,200,90);
wind     = addSlider(main,"Wind Speed (m/s)",0,20,2);
emis     = addSlider(main,"Emissivity (0-1)",0,1,0.5);
I_send   = addField(main,"Sending Current (A)",100);
I_recv   = addField(main,"Receiving Current (A)",95);
uilabel(main,"Text","Conductor Type","FontSize",13);
ctype = uidropdown(main,"Items",{'ACSR','Copper','AAAC'},"Value",'ACSR');
btn = uibutton(main,"Text","Compute Ampacity Score","FontSize",14,...
   "FontWeight","bold","ButtonPushedFcn",@compute);
btn.Layout.Column = [1 2];
gauge = uigauge(main,'semicircular');
gauge.Layout.Column = [1 2];
gauge.Limits = [0 100];
gauge.MajorTicks = 0:20:100;
gauge.Value = 0;
suggest = uilabel(main,"Text","Result will appear here...",...
   "FontSize",14,"FontWeight","bold","HorizontalAlignment","center","FontColor",[0.2 0.2 0.2]);
suggest.Layout.Column = [1 2];
function compute(~,~)
   sigma = 5.670374419e-8;
   d  = D.Value;
   r  = rho25.Value;
   a  = alpha.Value;
   to = T_op.Value;
   ta = T_amb.Value;
   tm = T_allow.Value;
   v  = wind.Value;
   e  = emis.Value;
   Is = I_send.Value;
   Ir = I_recv.Value;
   ct = ctype.Value;
   A = pi*(d/2)^2;
   rhoT = r * (1 + a*(to - 25));
   Rm = rhoT/A;
   P = pi*d;
   h = 3 + 5.7*v;
   Qc = h*P*(tm - ta);
   Qr = e*sigma*P*((tm+273)^4 - (ta+273)^4);
   Qt = Qc + Qr;
   Iamp = sqrt(Qt/Rm);
   Imax = max(abs(Is),abs(Ir));
   U = Imax/Iamp;
   if U<=0.7
       S=100;
   elseif U<=1
       S=100-((U-0.7)/0.3)*40;
   elseif U<=1.2
       S=60-((U-1)/0.2)*40;
   else
       S=max(0,20-((U-1.2)/1)*20);
   end
   if Imax>0
       imb = abs(Is-Ir)/Imax;
   else
       imb = 0;
   end
   S = S*(1-min(0.15,0.15*imb));
   if strcmpi(ct,'ACSR') && d<0.02
       S = S-5;
   end
   finalScore = max(0,min(100,round(S)));
   gauge.Value = finalScore;
   if finalScore > 85
       msg = "Excellent! Conductor is well within safe limits.";
   elseif finalScore > 60
       msg = "Good, but monitor loading or consider slight overdesign.";
   elseif finalScore > 35
       msg = "Near critical. Increasing conductor size is recommended.";
   else
       msg = "Unsafe! High risk of overheating. Redesign required!";
   end
   suggest.Text = msg;
end
end
function f = addField(parent,label,val)
   uilabel(parent,"Text",label,"FontSize",13);
   f = uieditfield(parent,"numeric","Value",val);
end
function s = addSlider(parent,label,min,max,val)
   uilabel(parent,"Text",label,"FontSize",13);
   s = uislider(parent,"Limits",[min max],"Value",val);
end
